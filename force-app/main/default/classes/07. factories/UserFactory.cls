public with sharing class UserFactory {

    public static List<User> assemble(List<Profile> profiles) {

        List<User> users = new List<User>();

        // Rôle générique pour les tests
        UserRole r = new UserRole(Name = 'TestRole');
        insert r;

        for (Profile p : profiles) {

            Long ts = System.currentTimeMillis();

            User u = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'test.user+' + ts + '@example.com',
                Username = 'test.user+' + ts + '@example.com',
                Alias = 'tuser',
                TimeZoneSidKey = 'Europe/Paris',
                LocaleSidKey = 'fr_FR',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'fr',
                ProfileId = p.Id,
                UserRoleId = r.Id
            );

            users.add(u);
        }

        return users;
    }
}

