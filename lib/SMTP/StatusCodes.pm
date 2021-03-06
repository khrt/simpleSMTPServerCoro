package SMTP::StatusCodes;

use strict;
use warnings;

use base 'Exporter';

use constant AUTH_READY    => 334;
use constant AUTH_SUCCESS  => 235;
use constant AUTH_REQUIRED => 530;
use constant AUTH_FAILED   => 535;

use constant SYSTEM_STATUS                => 211;
use constant SYSTEM_HELP_REPLY            => 211;
use constant HELP_MESSAGE                 => 214;
use constant READY                        => 220;
use constant CLOSING_TRANSMISSION         => 221;
use constant OK                           => 250;
use constant USER_NOT_LOCAL               => 251;
use constant CANNOT_VRFY_USER             => 252;

use constant START_MAIL_INPUT             => 354;

use constant NOT_AVAILABLE                => 421;
#use constant MAILBOX_UNAVAILABLE          => 450;
use constant ERROR_IN_PROCESSING          => 451;
use constant INSUFFICIENT_SYSTEM_STORAGE  => 452;
use constant UNABLE_TO_ACCOMMODATE_PARAMETERS => 455;

use constant SYNTAX_ERROR                 => 500;
use constant COMMAND_UNRECOGNIZED         => 500;
use constant ERROR_IN_PARAMETERS          => 501;
use constant COMMAND_NOT_IMPLEMENTED      => 502;
use constant BAD_SEQUENCE_OF_COMMANDS     => 503;
use constant PARAMETER_NOT_IMPLEMENTED    => 504;
use constant MAILBOX_UNAVAILABLE          => 550;
#use constant USER_NOT_LOCAL               => 551;
use constant EXCEEDED_STORAGE_ALLOCATION  => 552;
use constant MAILBOX_NAME_NOT_ALLOWED     => 553;
use constant TRANSACTION_FAILED           => 554;
use constant NO_SMTP_SERVICE_HERE         => 554;
use constant PARAMETERS_NOT_RECOGNIZED    => 555;

our @EXPORT = qw(
AUTH_READY
AUTH_SUCCESS
AUTH_FAILED

SYSTEM_STATUS
SYSTEM_HELP_REPLY
HELP_MESSAGE READY
CLOSING_TRANSMISSION
OK
USER_NOT_LOCAL
CANNOT_VRFY_USER

START_MAIL_INPUT

NOT_AVAILABLE
MAILBOX_UNAVAILABLE
ERROR_IN_PROCESSING
INSUFFICIENT_SYSTEM_STORAGE
UNABLE_TO_ACCOMMODATE_PARAMETERS

SYNTAX_ERROR
COMMAND_UNRECOGNIZED
ERROR_IN_PARAMETERS
COMMAND_NOT_IMPLEMENTED
BAD_SEQUENCE_OF_COMMANDS
PARAMETER_NOT_IMPLEMENTED
MAILBOX_UNAVAILABLE
USER_NOT_LOCAL
EXCEEDED_STORAGE_ALLOCATION
MAILBOX_NAME_NOT_ALLOWED
TRANSACTION_FAILED
NO_SMTP_SERVICE_HERE
PARAMETERS_NOT_RECOGNIZED
);

1;
