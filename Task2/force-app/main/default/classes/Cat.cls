public with sharing class Cat {
    String name;
    Integer birthYear;
    String color;
    String owner;

    public Cat(String name) {
        this.name = name;
    }

    public Cat(String name, Integer birthYear, String color) {
        this(name);
        this.birthYear = birthYear;
        this.color = color;
    }

    public Cat(String name, Integer birthYear, String color, String owner) {
        this(name, birthYear, color);
        this.owner = owner;
    }

    public Boolean adoptCat(String ownerName) {
        if (this.owner != null) {
            System.debug('This cat already has an owner.');
            return false;
        }
        this.owner = ownerName;
        return true;
    }

    public String callCat(String catName) {
        if (this.name == catName) {
            return 'Cat is on its way';
        }
        return 'Cat ignored You';
    }

    public Integer checkCatsAge() {
        if (this.birthYear != null) {
            return Date.today().year() - this.birthYear;
        }
        return null;
    }

    public static void meow() {
        System.debug('Meow');
    }

    public static void runExamples() {
        Cat c1 = new Cat('Luna');
        Cat c2 = new Cat('Milo', 2020, 'Black');
        Cat c3 = new Cat('Whiskers', 2018, 'White', 'Alice');

        System.debug(c1.adoptCat('Bob'));
        System.debug(c3.adoptCat('Tom'));

        System.debug(c2.callCat('Milo'));
        System.debug(c2.callCat('Oscar'));

        System.debug(c2.checkCatsAge());

        Cat.meow();
    }
}
