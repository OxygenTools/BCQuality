codeunit 50400 "Test UI Handler Capture Good"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('CustomerCardHandler')]
    procedure CustomerCardShowsSelectedCustomer()
    var
        Customer: Record Customer;
    begin
        Customer.Get('10000');
        CapturedCustomerNo := '';

        Page.RunModal(Page::"Customer Card", Customer);

        Assert.AreEqual(Customer."No.", CapturedCustomerNo, 'The customer card opened for the wrong customer.');
    end;

    [ModalPageHandler]
    procedure CustomerCardHandler(var CustomerCard: TestPage "Customer Card")
    begin
        CapturedCustomerNo := CustomerCard."No.".Value();
    end;

    var
        Assert: Codeunit "Library Assert";
        CapturedCustomerNo: Code[20];
}
