tableextension 50113 "Dimension Value Ext" extends "Dimension Value"
{
    trigger OnBeforeInsert()
    begin
        CompInfo.GET;
        IF CompInfo."Master Company" = false then
            Error('Dimension Insert allow only master company');
    end;

    trigger OnBeforeModify()
    begin
        CompInfo.GET;
        IF CompInfo."Master Company" = false then
            Error('Dimension modify allow only master company');
    end;

    trigger OnBeforeDelete()
    begin
        CompInfo.GET;
        IF CompInfo."Master Company" = false then
            Error('Dimension delete allow only master company');
    end;

    trigger OnBeforeRename()
    begin
        CompInfo.GET;
        IF CompInfo."Master Company" = false then
            Error('Dimension Rename allow only master company');
    end;

    var
        CompInfo: Record "Company Information";
}