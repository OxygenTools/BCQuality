codeunit 50401 "Test UI Handler Proof Bad"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('CustomerCardHandler')]
    procedure CustomerCardActionSucceeds()
    var
        Customer: Record Customer;
    begin
        Customer.Get('10000');
        ActionSucceeded := true;

        Page.RunModal(Page::"Customer Card", Customer);

        // This only proves a value assigned before the action stayed true.
        Assert.IsTrue(ActionSucceeded, 'The customer card action failed.');
    end;

    [ModalPageHandler]
    procedure CustomerCardHandler(var CustomerCard: TestPage "Customer Card")
    begin
    end;

    var
        Assert: Codeunit "Library Assert";
        ActionSucceeded: Boolean;
}
