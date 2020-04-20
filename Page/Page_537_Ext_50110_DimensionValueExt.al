pageextension 50110 "Dimension Value Ext" extends "Dimension Values"
{
    layout
    {

    }
    actions
    {
        addafter("Indent Dimension Values")
        {
            action("Sync Dimension")
            {
                ApplicationArea = Dimensions;
                Caption = 'Sync Dimension';
                Image = DefaultDimension;
                trigger OnAction()
                var
                begin
                    SyncDimension();
                end;
            }
        }
    }
    procedure SyncDimension()
    var
        Company: Record Company;
        DimensionValue: Record "Dimension Value";
        DimValue: Record "Dimension Value";
        CompanyInformation: Record "Company Information";
        BusinessUnit: Record "Business Unit";
        Dimension: Record Dimension;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Text001: Label 'You are not allowed to Sync dimension';
        Text002: Label 'Records has been synced';
    begin
        CompanyInformation.GET;
        IF CompanyInformation."Master Company" = false then
            Error(Text001);

        BusinessUnit.Reset;
        IF BusinessUnit.FindSet then begin
            repeat
                DimensionValue.ChangeCompany(BusinessUnit."Company Name");
                Dimension.CHANGECOMPANY(BusinessUnit."Company Name");
                GeneralLedgerSetup.ChangeCompany(BusinessUnit."Company Name");
                GeneralLedgerSetup.Get;

                Dimension.RESET;
                Dimension.SETRANGE(Code, "Dimension Code");
                IF NOT Dimension.FINDFIRST THEN
                    ERROR('Dimension %1 does not exists', Dimension.Code);

                DimValue.RESET;
                DimValue.SETCURRENTKEY("Dimension Code", Code);
                DimValue.SETRANGE("Dimension Code", "Dimension Code");
                IF DimValue.FINDSET THEN begin
                    REPEAT
                        DimensionValue.RESET;
                        DimensionValue.SETCURRENTKEY("Dimension Code", Code);
                        DimensionValue.SETRANGE("Dimension Code", DimValue."Dimension Code");
                        DimensionValue.SETRANGE(Code, DimValue.Code);
                        IF NOT DimensionValue.FINDFIRST THEN BEGIN
                            DimensionValue.INIT;
                            DimensionValue."Dimension Code" := DimValue."Dimension Code";
                            DimensionValue.Code := DimValue.Code;
                            DimensionValue.Name := DimValue.Name;
                            DimensionValue."Dimension Value Type" := DimValue."Dimension Value Type";
                            DimensionValue.Totaling := DimValue.Totaling;
                            DimensionValue.Blocked := DimValue.Blocked;
                            DimensionValue."Consolidation Code" := DimValue."Consolidation Code";
                            DimensionValue.Indentation := DimValue.Indentation;
                            DimensionValue."Map-to IC Dimension Code" := DimValue."Map-to IC Dimension Code";
                            DimensionValue."Map-to IC Dimension Value Code" := DimValue."Map-to IC Dimension Value Code";
                            DimensionValue."Global Dimension No." := GetGlobalDimensionNo;
                            DimensionValue.INSERT;
                        END ELSE BEGIN
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", DimValue."Dimension Code");
                            DimensionValue.SETRANGE(Code, DimValue.Code);
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                DimensionValue.Name := DimValue.Name;
                                DimensionValue."Dimension Value Type" := DimValue."Dimension Value Type";
                                DimensionValue.Totaling := DimValue.Totaling;
                                DimensionValue.Blocked := DimValue.Blocked;
                                DimensionValue."Consolidation Code" := DimValue."Consolidation Code";
                                DimensionValue.Indentation := DimValue.Indentation;
                                DimensionValue."Map-to IC Dimension Code" := DimValue."Map-to IC Dimension Code";
                                DimensionValue."Map-to IC Dimension Value Code" := "Map-to IC Dimension Value Code";
                                DimensionValue."Global Dimension No." := GetGlobalDimensionNo;
                                DimensionValue."Last Modified Date Time" := CurrentDateTime;
                                DimensionValue.MODIFY;
                            END;
                        END;
                    until DimValue.Next = 0;
                end;
            until BusinessUnit.Next = 0;
            Message(Text002);
        end;
    end;

    local procedure GetGlobalDimensionNo(): Integer
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get;
        case "Dimension Code" of
            GeneralLedgerSetup."Global Dimension 1 Code":
                exit(1);
            GeneralLedgerSetup."Global Dimension 2 Code":
                exit(2);
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                exit(3);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                exit(4);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                exit(5);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                exit(6);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                exit(7);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                exit(8);
            else
                exit(0);
        end;
    end;
}