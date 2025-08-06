public class SqlLearning {

    public static List<Contact> getContactsWithAccountFields() {
        return [
            SELECT Name, Email,
                Account.Name, Account.AnnualRevenue, Account.Industry
            FROM Contact
            WHERE AccountId != null
        ];
    }

    public static List<Contact> getContactsWithAccountAndOwner() {
        return [
            SELECT Name,
                Account.Name,
                Account.Owner.Name,
                Account.Owner.Email
            FROM Contact
            WHERE AccountId != null
        ];
    }

    public static List<Opportunity> getOpportunitiesWithAccountAndLineItems() {
        return [
            SELECT Name, StageName,
                Account.Type,
                Account.Owner.UserRole.Name,
                (SELECT Name, UnitPrice FROM OpportunityLineItems)
            FROM Opportunity
            WHERE AccountId != null
        ];
    }

    public static List<Account> getAccountsWithCases() {
        return [
            SELECT Name,
                (SELECT CaseNumber, Status, Priority FROM Cases)
            FROM Account
        ];
    }

    public static List<Account> getAccountsWithRecentOpportunities() {
        return [
            SELECT Name
            FROM Account
            WHERE Id IN (
                SELECT AccountId
                FROM Opportunity
                WHERE CloseDate = LAST_N_DAYS:30
            )
        ];
    }
}
