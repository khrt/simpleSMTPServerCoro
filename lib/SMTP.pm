package SMTP;

use strict;
use warnings;

use Carp;
use Coro;
use Coro::Event;
use Coro::Semaphore;
use Coro::Socket;
use IO::Socket::INET;
use IO::Socket::UNIX;

use SMTP::Commands;
use SMTP::StatusCodes;
use SMTP::Session;

my $MAX_CONNECTS = 100;

$SIG{PIPE} = 'IGNORE';

sub new {
    my ($class, %args) = @_;

    my $self = bless { %args }, $class;

    my $daemon = do {
        if ($args{unix}) {
            unlink $args{unix} if -e $args{unix};
            Coro::Socket->new_from_fh(
                IO::Socket::UNIX->new(
                    Local => $args{unix},
                    Type => SOCK_STREAM,
                    Listen => 1,
                )
            );
        }
        else {
            my ($addr, $port) = split ':', $args{listen};
            Coro::Socket->new(
                LocalAddr => $addr,
                LocalPort => $port,
                ReuseAddr => 1,
                Listen => 1,
            );
        }
    };

    $daemon or croak 'Unable to start daemon!';

    $self->{daemon} = $daemon;
    $self->{connects} = Coro::Semaphore->new($args{max_connects} || $MAX_CONNECTS);

    $self;
}

sub name { shift->{name} || 'Perl SMTPd RFC5321' }

sub address {
    my $self = shift;

    if ($self->{unix}) {
        return 'SOCKET';
    }
    else {
        return $self->{listen};
    }
}

sub logger {
    my ($self, $level, $str, @args) = @_;
    chomp $str;
    my $msg = sprintf("%s: $str", uc($level), @args);
    use feature 'say';
    say $msg;
}

sub run {
    my $self = shift;

    async { loop() };

    $self->logger(info => 'Listening on: %s', $self->address);
    while (1) {
        $self->{connects}->down;

        if (my $fh = $self->{daemon}->accept) {
            async_pool {
                eval { SMTP::Session->new(daemon => $self, fh => $fh)->handle };
                $self->logger(error => $@) if $@;

                close $fh;
                $self->{connects}->up;
            }
        }
    }
}

sub process_message {
    my ($self, $cb) = @_;
    $self->{process_message} = $cb if $cb;
    $self->{process_message};
}

sub on {
    my ($self, $name, $cb) = @_;

    if ($name && $cb) {
        if (ref $cb ne 'CODE') {
            carp "Failed to add callback `$name'. It's not a CODEREF";
            return;
        }

        if ($self->{callback_list}{$name}) {
            carp "`$name' has been redefined";
        }

        $self->{callback_list}{$name} = $cb;
    }

    my $default_cb = sub {
        carp "UNDEFINED METHOD `$name' CALLED";
        1;
    };

    $self->{callback_list}{$name} || $default_cb;
}

1;

__END__
https://tools.ietf.org/html/rfc2034
https://tools.ietf.org/html/rfc1893
http://tools.ietf.org/html/rfc4954#section-4
http://tools.ietf.org/html/rfc5321#section-4.1.1
https://github.com/andris9/simplesmtp/blob/master/lib/server.js
