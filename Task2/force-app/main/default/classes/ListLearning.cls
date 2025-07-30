public class ListLearning {

    public static void task1() {
        List<String> fruits = new List<String>{'Apple', 'Banana', 'Cherry'};
        for (String fruit : fruits) {
            System.debug(fruit);
        }
        fruits.add('Dragonfruit');
        System.debug(fruits[fruits.size() - 1]);
    }

    public static void task2() {
        List<String> animals = new List<String>{null, null, null};
        animals[1] = 'Cats';
        animals.add('Dogs');
        System.debug(animals);
    }

    public static void task3() {
        Integer currentMonth = 7;

        List<Integer> winter = new List<Integer>{12, 1, 2};
        List<Integer> spring = new List<Integer>{3, 4, 5};
        List<Integer> summer = new List<Integer>{6, 7, 8};
        List<Integer> autumn = new List<Integer>{9, 10, 11};

        if (winter.contains(currentMonth)) {
            System.debug('It’s winter');
        } else if (spring.contains(currentMonth)) {
            System.debug('It’s spring');
        } else if (summer.contains(currentMonth)) {
            System.debug('It’s summer');
        } else if (autumn.contains(currentMonth)) {
            System.debug('It’s autumn');
        } else {
            System.debug('Invalid month');
        }

        switch on currentMonth {
            when 12, 1, 2 {
                System.debug('It’s winter');
            }
            when 3, 4, 5 {
                System.debug('It’s spring');
            }
            when 6, 7, 8 {
                System.debug('It’s summer');
            }
            when 9, 10, 11 {
                System.debug('It’s autumn');
            }
            when else {
                System.debug('Invalid month');
            }
        }
    }
}
