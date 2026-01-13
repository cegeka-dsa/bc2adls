// Licensed under the MIT License. See LICENSE in the project root for license information.
namespace Zig.ADLSE;

enum 11007163 "ADLSE Process Type"
{
    Access = Internal;
    Extensible = false;
    ObsoleteState = Pending;
    ObsoleteTag = '27.44';
    ObsoleteReason = 'This field will be removed in a future release because readuncommitted will be the default behavior because of performance.';

    value(0; "Standard")
    {
        Caption = 'Standard';
    }
    value(1; "Ignore Read Isolation")
    {
        Caption = 'Ignore Read Isolation';
    }
    value(2; "Commit Externally")
    {
        Caption = 'Commit Externally';
    }
}