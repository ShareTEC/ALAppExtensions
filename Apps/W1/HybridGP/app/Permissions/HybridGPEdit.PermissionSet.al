permissionset 4031 "HybridGP - Edit"
{
    Assignable = false;
    Access = Public;
    Caption = 'HybridGP" - Edit';

    IncludedPermissionSets = "HybridGP - Read";

    Permissions = tabledata "GP Account" = IMD,
                    tabledata "GP Fiscal Periods" = IMD,
                    tabledata "GP GLTransactions" = IMD,
                    tabledata "GP Customer" = IMD,
                    tabledata "GP Customer Transactions" = IMD,
                    tabledata "GPIVBinQtyTransferHist" = IMD,
                    tabledata "GPIVDistributionHist" = IMD,
                    tabledata "GPIVLotAttributeHist" = IMD,
                    tabledata "GPIVSerialLotNumberHist" = IMD,
                    tabledata "GPIVTrxAmountsHist" = IMD,
                    tabledata "GPIVTrxBinQtyHist" = IMD,
                    tabledata "GPIVTrxDetailHist" = IMD,
                    tabledata "GPIVTrxHist" = IMD,
                    tabledata "GPPMHist" = IMD,
                    tabledata "GPPOPBinQtyHist" = IMD,
                    tabledata "GPPOPDistributionHist" = IMD,
                    tabledata "GPPOPLandedCostHist" = IMD,
                    tabledata "GPPOPPOHist" = IMD,
                    tabledata "GPPOPPOLineHist" = IMD,
                    tabledata "GPPOPPOTaxHist" = IMD,
                    tabledata "GPPOPReceiptApply" = IMD,
                    tabledata "GPPOPReceiptHist" = IMD,
                    tabledata "GPPOPReceiptLineHist" = IMD,
                    tabledata "GPPOPSerialLotHist" = IMD,
                    tabledata "GPPOPTaxHist" = IMD,
                    tabledata "GPRMHist" = IMD,
                    tabledata "GPRMOpen" = IMD,
                    tabledata "GPSOPBinQuantityWorkHist" = IMD,
                    tabledata "GPSOPCommissionsWorkHist" = IMD,
                    tabledata "GPSOPDepositHist" = IMD,
                    tabledata "GPSOPDistributionWorkHist" = IMD,
                    tabledata "GPSOPLineCommentWorkHist" = IMD,
                    tabledata "GPSOPPaymentWorkHist" = IMD,
                    tabledata "GPSOPProcessHoldWorkHist" = IMD,
                    tabledata "GPSOPSerialLotWorkHist" = IMD,
                    tabledata "GPSOPTaxesWorkHist" = IMD,
                    tabledata "GPSOPTrackingNumbersWorkHist" = IMD,
                    tabledata "GPSOPTrxAmountsHist" = IMD,
                    tabledata "GPSOPTrxHist" = IMD,
                    tabledata "GPSOPUserDefinedWorkHist" = IMD,
                    tabledata "GPSOPWorkflowWorkHist" = IMD,
#pragma warning disable AL0432
                    tabledata "GPForecastTemp" = IMD,
#pragma warning restore AL0432
                    tabledata "GP Item" = IMD,
                    tabledata "GP Item Location" = IMD,
                    tabledata "GP Item Transactions" = IMD,
                    tabledata "GP Codes" = IMD,
                    tabledata "GP Configuration" = IMD,
                    tabledata "GP Payment Terms" = IMD,
                    tabledata "GP Posting Accounts" = IMD,
                    tabledata "GP Segments" = IMD,
                    tabledata "GP Bank MSTR" = IMD,
                    tabledata "GP Checkbook MSTR" = IMD,
                    tabledata "GP Checkbook Transactions" = IMD,
                    tabledata "GP POPPOHeader" = IMD,
                    tabledata "GP POPPOLine" = IMD,
                    tabledata "GP Vendor" = IMD,
                    tabledata "GP Vendor Transactions" = IMD,
                    tabledata "GP Company Migration Settings" = IMD,
                    tabledata "GP Migration Errors" = IMD,
                    tabledata "GP Segment Name" = IMD,
                    tabledata "GP Company Additional Settings" = IMD,
                    tabledata "GP SY40100" = IMD,
                    tabledata "GP SY40101" = IMD,
                    tabledata "GP CM20600" = IMD,
                    tabledata "GP MC40200" = IMD,
                    tabledata "GP SY06000" = IMD,
                    tabledata "GP PM00100" = IMD,
                    tabledata "GP PM00200" = IMD,
                    tabledata "GP RM00101" = IMD,
                    tabledata "GP RM00201" = IMD,
                    tabledata "GP GL00100" = IMD,
                    tabledata "GP GL10110" = IMD,
                    tabledata "GP GL10111" = IMD,
                    tabledata "GP GL40200" = IMD,
                    tabledata "GP IV00101" = IMD,
                    tabledata "GP IV00102" = IMD,
                    tabledata "GP IV00105" = IMD,
                    tabledata "GP IV00200" = IMD,
                    tabledata "GP IV00300" = IMD,
                    tabledata "GP IV10200" = IMD,
                    tabledata "GP IV40201" = IMD,
                    tabledata "GP IV40400" = IMD,
                    tabledata "GP MC40000" = IMD,
                    tabledata "GP PM00201" = IMD,
                    tabledata "GP PM20000" = IMD,
                    tabledata "GP RM00103" = IMD,
                    tabledata "GP RM20101" = IMD,
                    tabledata "GP SY00300" = IMD,
                    tabledata "GP SY01100" = IMD,
                    tabledata "GP SY01200" = IMD,
                    tabledata "GP SY03300" = IMD;
}
