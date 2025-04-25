namespace app.app;

using Zig.ADLSE;

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.

page 11007178 "ADLSE Parallel Proc Setup"
{
    ApplicationArea = All;
    Caption = 'ADLSE Parallel Processing Setup';
    PageType = List;
    SourceTable = "ADLSE Parallel Proc Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the primary key for the table.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the table ID for the parallel processing.';
                }
                field("Start RecordId"; Rec."Start RecordId")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the starting record ID for the parallel processing.';
                }
                field("End RecordId"; Rec."End RecordId")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the ending record ID for the parallel processing.';
                }
            }
        }
    }
}
