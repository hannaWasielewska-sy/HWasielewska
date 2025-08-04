@isTest
public class CatTest {
    
    @isTest
    static void testCatConstructors() {
        // 1
        Cat cat1 = new Cat('Luna');
        System.assertEquals('Luna', cat1.name, 'Name should be set correctly');
        // 2
        Cat cat2 = new Cat('Milo', 2020, 'Black');
        System.assertEquals('Milo', cat2.name, 'Name should be set correctly');
        System.assertEquals(2020, cat2.birthYear, 'Birth year should be set correctly');
        System.assertEquals('Black', cat2.color, 'Color should be set correctly');
        // 3
        Cat cat3 = new Cat('Whiskers', 2018, 'White', 'Alice');
        System.assertEquals('Whiskers', cat3.name, 'Name should be set correctly');
        System.assertEquals(2018, cat3.birthYear, 'Birth year should be set correctly');
        System.assertEquals('White', cat3.color, 'Color should be set correctly');
        System.assertEquals('Alice', cat3.owner, 'Owner should be set correctly');
    }
    
    @isTest
    static void testAdoptCat() {
        Cat cat = new Cat('Luna');
        
        // kot nie ma właściciela
        Boolean result1 = cat.adoptCat('Bob');
        System.assertEquals(true, result1, 'Adoption should be successful for cat without owner');
        
        // kot ma właściciela
        Boolean result2 = cat.adoptCat('Tom');
        System.assertEquals(false, result2, 'Adoption should fail for cat with existing owner');
    }
    
    @isTest
    static void testCallCat() {
        Cat cat = new Cat('Milo');
        
        String result1 = cat.callCat('Milo');
        System.assertEquals('Cat is on its way', result1, 'Cat should respond to its name');
        
        String result2 = cat.callCat('Oscar');
        System.assertEquals('Cat ignored You', result2, 'Cat should ignore wrong name');
    }
    
    @isTest
    static void testCheckCatsAge() {

        Cat cat1 = new Cat('Milo', 2020, 'Black');
        Integer age1 = cat1.checkCatsAge();
        System.assertNotEquals(null, age1, 'Age should be calculated when birth year is provided');
        System.assert(age1 > 0, 'Age should be positive');
      
        Cat cat2 = new Cat('Luna');
        Integer age2 = cat2.checkCatsAge();
        System.assertEquals(null, age2, 'Age should be null when birth year is not provided');
    }
    
    @isTest
    static void testMeow() {
        
        Test.startTest();
        Cat.meow();
        Test.stopTest();
    }
    
    @isTest
    static void testRunExamples() {
        
        Test.startTest();
        Cat.runExamples();
        Test.stopTest();
        
    }
} 