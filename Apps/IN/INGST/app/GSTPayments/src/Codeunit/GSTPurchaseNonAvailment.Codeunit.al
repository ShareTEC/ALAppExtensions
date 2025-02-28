codeunit 18251 "GST Purchase Non Availment"
{
    var
        GSTBaseValidation: Codeunit "GST Base Validation";
        GSTNonAvailmentSessionMgt: Codeunit "GST Non Availment Session Mgt";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostItemJnlLine', '', false, false)]
    local procedure QuantityToBeInvoiced(var QtyToBeInvoiced: Decimal)
    begin
        GSTNonAvailmentSessionMgt.SetQtyToBeInvoiced(QtyToBeInvoiced);
    end;

#if not CLEAN20
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure FillInvoicePostingBufferNonAvailmentFA(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    var
        QtyFactor: Decimal;
        CustomDutyLoaded: Decimal;
    begin
        if (PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset") and (PurchaseLine."GST Credit" = PurchaseLine."GST Credit"::"Non-Availment") then begin
            QtyFactor := PurchaseLine."Qty. to Invoice" / PurchaseLine.Quantity;
            InvoicePostBuffer."FA Non-Availment Amount" := Round(GSTCalculatedAmount(PurchaseLine) * QtyFactor);
            CustomDutyLoaded := GSTNonAvailmentSessionMgt.GetCustomDutyAmount();
            InvoicePostBuffer."FA Non-Availment" := true;

            if CustomDutyLoaded <> 0 then
                InvoicePostBuffer."FA Non-Availment Amount" += Round(CustomDutyLoaded * QtyFactor);
        end;
    end;
#else
    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', false, false)]
    local procedure FillInvoicePostingBufferNonAvailmentFA(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; var PurchaseLine: Record "Purchase Line")
    var
        QtyFactor: Decimal;
        CustomDutyLoaded: Decimal;
    begin
        if (PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset") and (PurchaseLine."GST Credit" = PurchaseLine."GST Credit"::"Non-Availment") then begin
            QtyFactor := PurchaseLine."Qty. to Invoice" / PurchaseLine.Quantity;
            InvoicePostingBuffer."FA Non-Availment Amount" := Round(GSTCalculatedAmount(PurchaseLine) * QtyFactor);
            CustomDutyLoaded := GSTNonAvailmentSessionMgt.GetCustomDutyAmount();
            InvoicePostingBuffer."FA Non-Availment" := true;

            if CustomDutyLoaded <> 0 then
                InvoicePostingBuffer."FA Non-Availment Amount" += Round(CustomDutyLoaded * QtyFactor);
        end;
    end;
#endif

#if not CLEAN20
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferModify', '', false, false)]
    local procedure UpdateInvoicePostingBufferNonAvailmentFA(FromInvoicePostBuffer: Record "Invoice Post. Buffer"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."FA Non-Availment Amount" += FromInvoicePostBuffer."FA Non-Availment Amount";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', false, false)]
    local procedure FillGenJournalLineNonAvailmentFA(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."FA Non-Availment" := InvoicePostBuffer."FA Non-Availment";
        GenJnlLine."FA Non-Availment Amount" := InvoicePostBuffer."FA Non-Availment Amount";
    end;
#else
    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnUpdateOnAfterModify', '', false, false)]
    local procedure UpdateInvoicePostingBufferNonAvailmentFA(FromInvoicePostingBuffer: Record "Invoice Posting Buffer"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        InvoicePostingBuffer."FA Non-Availment Amount" += FromInvoicePostingBuffer."FA Non-Availment Amount";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', false, false)]
    local procedure FillGenJournalLineNonAvailmentFA(InvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."FA Non-Availment" := InvoicePostingBuffer."FA Non-Availment";
        GenJnlLine."FA Non-Availment Amount" := InvoicePostingBuffer."FA Non-Availment Amount";
    end;
#endif

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforePostFixedAssetFromGenJnlLine', '', false, false)]
    local procedure UpdateFANonAvailmentAmount(var FALedgerEntry: Record "FA Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."FA Non-Availment" then
            FALedgerEntry.Amount += GenJournalLine."FA Non-Availment Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostFixedAssetOnBeforeInitGLEntryFromTempFAGLPostBuf', '', false, false)]
    local procedure UpdateTempFAGLPostBufNonAvailment(var GenJournalLine: Record "Gen. Journal Line"; var TempFAGLPostBuf: Record "FA G/L Posting Buffer")
    begin
        if GenJournalLine."FA Non-Availment" then
            TempFAGLPostBuf.Amount -= GenJournalLine."FA Non-Availment Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnAfterPrepareItemJnlLine', '', false, false)]
    local procedure LoadGSTUnitCost(PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; var ItemJournalLine: Record "Item Journal Line")
    var
        QtytoBeInvoiced: Decimal;
        QtyFactor: Decimal;
        GSTAmountLoaded: Decimal;
        CustomDutyLoaded: Decimal;
    begin
        QtytoBeInvoiced := GSTNonAvailmentSessionMgt.GetQtyToBeInvoiced();
        GSTAmountLoaded := GSTNonAvailmentSessionMgt.GetGSTAmountToBeLoaded();
        CustomDutyLoaded := GSTNonAvailmentSessionMgt.GetCustomDutyAmount();
        if GSTAmountLoaded = 0 then
            exit;

        if PurchaseLine."Qty. to Invoice" <> 0 then
            QtyFactor := QtytoBeInvoiced / PurchaseLine."Qty. to Invoice";

        if PurchaseLine."Document Type" in [PurchaseLine."Document Type"::"Credit Memo", PurchaseLine."Document Type"::"Return Order"] then
            ItemJournalLine.Amount := ItemJournalLine.Amount - Round(GSTAmountLoaded * QtyFactor)
        else
            ItemJournalLine.Amount := ItemJournalLine.Amount + Round(GSTAmountLoaded * QtyFactor);

        if (PurchaseHeader."GST Vendor Type" in
            [PurchaseHeader."GST Vendor Type"::SEZ, PurchaseHeader."GST Vendor Type"::Import]) and
            (CustomDutyLoaded <> 0) and (PurchaseLine."Qty. to Invoice" <> 0) then
            ItemJournalLine.Amount := ItemJournalLine.Amount + CustomDutyLoaded / PurchaseLine."Qty. to Invoice" * ItemJournalLine."Invoiced Quantity";

        if QtyToBeInvoiced <> 0 then
            ItemJournalLine."Unit Cost" := ItemJournalLine."Unit Cost" + ((GSTAmountLoaded + CustomDutyLoaded) * QtyFactor / QtyToBeInvoiced)
        else
            if (PurchaseLine."Qty. to Receive" > PurchaseLine."Qty. to Invoice") and (PurchaseLine."Qty. to Invoice" <> 0) and PurchaseHeader.Invoice then
                ItemJournalLine."Unit Cost" := ItemJournalLine."Unit Cost" + ((GSTAmountLoaded + CustomDutyLoaded) * QtyFactor / PurchaseLine."Qty. to Invoice");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostPurchLineOnAfterSetEverythingInvoiced', '', false, false)]
    local procedure GetAmounts(PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        LoadGSTAmount: Decimal;
    begin
        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        LoadGSTAmount := GSTCalculatedAmount(PurchaseLine);

        if LoadGSTAmount = 0 then begin
            GSTNonAvailmentSessionMgt.SetGSTAmountToBeLoaded(LoadGSTAmount);
            exit;
        end;

        if (PurchaseLine.Type <> PurchaseLine.Type::"Charge (Item)") and (not PurchaseHeader."GST Input Service Distribution") then
            GSTNonAvailmentSessionMgt.SetGSTAmountToBeLoaded(LoadGSTAmount);
    end;

    local procedure GSTCalculatedAmount(PurchaseLine: Record "Purchase Line"): Decimal;
    var
        GSTSetup: Record "GST Setup";
        PurchaseHeader: Record "Purchase Header";
        GSTGroup: Record "GST Group";
        TransactionGSTAmount: Decimal;
        TransactionCessAmount: Decimal;
        GSTAmountToBeLoaded: Decimal;
        CustomDuty: Decimal;
        Sign: Integer;
    begin
        if not GSTSetup.Get() then
            exit;

        if not PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
            exit;

        if not GSTGroup.Get(PurchaseLine."GST Group Code") then
            exit;

        if PurchaseLine."GST Credit" = PurchaseLine."GST Credit"::"Non-Availment" then
            TransactionGSTAmount := GetTaxAmount(GSTSetup."GST Tax Type", PurchaseLine.RecordId);

        if (PurchaseHeader."GST Vendor Type" in [PurchaseHeader."GST Vendor Type"::Import, PurchaseHeader."GST Vendor Type"::SEZ]) and
            (PurchaseLine."GST Credit" = PurchaseLine."GST Credit"::"Non-Availment") and
            (PurchaseLine."Custom Duty Amount" <> 0) and
            not (PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"]) then begin
            CustomDuty := PurchaseLine."Custom Duty Amount";
            if PurchaseHeader."Currency Code" <> '' then
                CustomDuty := ConvertCustomDutyAmountToLCY(
                                PurchaseHeader."Currency Code",
                                PurchaseLine."Custom Duty Amount",
                                PurchaseHeader."Currency Factor",
                                PurchaseHeader."Posting Date");

            GSTNonAvailmentSessionMgt.SetCustomDutyAmount(CustomDuty);
        end else
            GSTNonAvailmentSessionMgt.SetCustomDutyAmount(0);

        if (GSTSetup."Cess Tax Type" <> '') and (GSTGroup."Cess Credit" = GSTGroup."Cess Credit"::"Non-Availment") then
            TransactionCessAmount := GetTaxAmount(GSTSetup."Cess Tax Type", PurchaseLine.RecordId);

        if (TransactionGSTAmount + TransactionCessAmount) <> 0 then
            GSTAmountToBeLoaded := GSTBaseValidation.RoundGSTPrecision((TransactionGSTAmount + TransactionCessAmount) * (PurchaseLine."Qty. to Invoice" / PurchaseLine.Quantity));

        if PurchaseLine."Document Type" in [PurchaseLine."Document Type"::Order,
            PurchaseLine."Document Type"::Invoice,
            PurchaseLine."Document Type"::Quote,
            PurchaseLine."Document Type"::"Blanket Order"] then
            Sign := 1
        else
            Sign := -1;

        exit(GSTAmountToBeLoaded * Sign);
    end;

    local procedure GetTaxAmount(TaxType: Code[20]; PurchaseLineTaxID: RecordId): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxAmount: Decimal;
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Type", TaxType);
        TaxTransactionValue.SetRange("Tax Record ID", PurchaseLineTaxID);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then
            repeat
                TaxAmount += RoundTaxAmount(TaxType, TaxTransactionValue."Value ID", TaxTransactionValue."Amount (LCY)");
            until TaxTransactionValue.Next() = 0;

        exit(TaxAmount);
    end;

    procedure RoundTaxAmount(TaxType: Code[20]; ID: Integer; TaxAmt: Decimal): Decimal
    var
        TaxComponent: Record "Tax Component";
        RoundedValue: Decimal;
        GSTRoundingDirection: Text[1];
    begin
        TaxComponent.Reset();
        TaxComponent.SetRange("Tax Type", TaxType);
        TaxComponent.SetRange(ID, ID);
        TaxComponent.SetFilter("Rounding Precision", '<>%1', 0);
        if TaxComponent.FindFirst() then begin
            case TaxComponent.Direction of
                TaxComponent.Direction::Nearest:
                    GSTRoundingDirection := '=';
                TaxComponent.Direction::Up:
                    GSTRoundingDirection := '>';
                TaxComponent.Direction::Down:
                    GSTRoundingDirection := '<';
            end;

            RoundedValue := Round(TaxAmt, TaxComponent."Rounding Precision", GSTRoundingDirection);
            exit(RoundedValue);
        end;

        exit(TaxAmt);
    end;

    local procedure ConvertCustomDutyAmountToLCY(CurrencyCode: Code[10]; Amount: Decimal; CurrencyFactor: Decimal; PostingDate: Date): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        if CurrencyCode <> '' then begin
            GeneralLedgerSetup.Get();
            GSTSetup.TestField("GST Tax Type");
            GeneralLedgerSetup.TestField("Custom Duty Component Code");
            TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxComponent.SetRange(name, Format(GeneralLedgerSetup."Custom Duty Component Code"));
            TaxComponent.FindFirst();
            exit(Round(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate, CurrencyCode, Amount, CurrencyFactor), TaxComponent."Rounding Precision"));
        end;
    end;
}