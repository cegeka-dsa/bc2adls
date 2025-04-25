namespace Zig.ADLSE;

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
#pragma warning disable LC0004, LC0015
table 11007174 "ADLSE Parallel Proc Setup"
#pragma warning restore
{
    Access = Internal;
    Caption = 'ADLSE Parallel Processing Setup';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            Caption = 'Primary Key';
            Editable = false;
            ToolTip = 'Specifies the primary key for the table.';
            AutoIncrement = true;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = true;
            ToolTip = 'Specifies the table ID for the parallel processing.';
            TableRelation = "ADLSE Table" where("Table ID" = field("Table ID"));

            trigger OnLookup()
            var
                ADSLETable: Record "ADLSE Table";
            begin
                if Page.RunModal(Page::"ADLSE Setup Tables", ADSLETable) = Action::LookupOK then
                    Validate("Table ID", ADSLETable."Table ID");
            end;
        }
        field(3; "Start RecordId"; RecordId)
        {
            Caption = 'Start RecordId';
            Editable = true;
            ToolTip = 'Specifies the starting record ID for the parallel processing.';
        }
        field(4; "End RecordId"; RecordId)
        {
            Caption = 'End RecordId';
            Editable = true;
            ToolTip = 'Specifies the ending record ID for the parallel processing.';
        }
        field(5; SessionId; Integer)
        {
            Caption = 'Session ID';
            Editable = false;
            ToolTip = 'Specifies the session ID for the parallel processing.';
        }
        // EITHER WERE USING RECORD ID FIELDS OR WE HAVE TO MAKE MULTIPLE PK FIELDS TO USE
        // THE ISSUE with record ids is that the use can not edit them in the UI
        // maybe we should make them use export and impor through excel?
        field(6; PK1Start; Text[250]) //making it a text is going to be an issue?
        {
            Caption = 'PK1';
            Editable = true;
            ToolTip = 'Specifies the primary key for the table.';
        }
        field(7; PK1End; Text[250]) // making it a text is going to be an issue?
        {
            Caption = 'PK1';
            Editable = true;
            ToolTip = 'Specifies the primary key for the table.';
        }
    }

    // trigger OnInsert()
    // begin
    //     // maybe we should set a max of records (sessions) per table and check it here?
    // end;

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
        // add key for table id if needed?
    }
}
