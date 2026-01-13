// Licensed under the MIT License. See LICENSE in the project root for license information.
namespace Zig.ADLSE;

table 11007180 "Session Instruction"
{
    Caption = 'Session Instruction';
    DataClassification = CustomerContent;
    ObsoleteState = Pending;
    ObsoleteReason = 'This table will be removed in a future release because readuncommitted will be the default behavior because of performance.';
    ObsoleteTag = '27.44';

    fields
    {
        field(1; "Session Id"; Integer)
        {
            Caption = 'Session Id';
        }
        field(2; "Object Type"; Option)
        {
            OptionMembers = ,Table,,Report,,Codeunit,,,,,,;
            OptionCaption = ',Table,,Report,,Codeunit,,,,,,';
            Caption = 'Object Type';
        }
        field(3; "Object ID"; Integer)
        {
            Caption = 'Codeunit ID';
        }
        field(4; Method; Enum "ADLSE Session Method")
        {
            Caption = 'Method';
        }
        field(5; Params; Text[250])
        {
            Caption = 'Params';
        }
        field(6; "Status"; Option)
        {
            OptionMembers = "In Progress",Finished,Failed;
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'In Progress,Finished,Failed';
        }
        field(7; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Session Id")
        {
            Clustered = true;
        }
    }

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure ExecuteInNewSession()
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure WaitForSession(NewSessionId: Integer; SessionStartTime: DateTime; SessionTimeout: Duration) SessionFound: Boolean;
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure RemoveSessionAndError(ErrorMessage: Text; Reason: Text)
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure DeleteStaleSessions()
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure CanInsertNewSession(NewSessionId: Integer): Boolean
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure Timeout(): Duration
    begin
    end;
}