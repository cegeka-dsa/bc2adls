namespace Zig.ADLSE;

#if not CLEAN27
codeunit 11007448 "ADLSE Method Imp. IncFileName" implements "ADLSE Session Method Interface"
{
    ObsoleteState = Pending;
    ObsoleteTag = '27.44';
    ObsoleteReason = 'This field will be removed in a future release because readuncommitted will be the default behavior because of performance.';

    var
        UndefinedMethodImp: Codeunit "ADLSE Method Imp. Undefined";
        MethodLbl: Label 'HandleIncreaseExportFileNumber';

    procedure Execute(Params: Text)
    var
        ADLSECommunication: Codeunit "ADLSE Communication";
        TableIdAsInt: Integer;
    begin
        Evaluate(TableIdAsInt, Params);
        if TableIdAsInt = 0 then
            UndefinedMethodImp.ErrorInvalidParameters(MethodLbl);
        ADLSECommunication.IncreaseExportFileNumber_InCurrSession(TableIdAsInt);
    end;
}
#endif