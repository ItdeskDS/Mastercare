pageextension 50112 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("Master Company"; "Master Company")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }
}