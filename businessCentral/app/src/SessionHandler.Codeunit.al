namespace Zig.ADLSE;

#if not CLEAN27
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 11007179 "Session Handler"
{
    TableNo = "Session Instruction";
    ObsoleteState = Pending;
    ObsoleteReason = 'This codeunit will be removed in a future release because readuncommitted will be the default behavior because of performance.';
    ObsoleteTag = '27.44';

    trigger OnRun()
    begin
    end;

    [Obsolete('This procedure will be removed in a future release because readuncommitted will be the default behavior because of performance.', '27.44')]
    procedure WrapRun(var SessionInstruction: Record "Session Instruction")
    begin
    end;
}
#endif