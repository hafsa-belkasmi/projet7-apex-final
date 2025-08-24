public class TestUtils {
    public static Account createTestAccount(String type) {
        Account acc = new Account(Name='Test Account', Type=type);
        insert acc;
        return acc;
    }
}