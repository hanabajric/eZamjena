using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;

namespace eZamjena
{
    public class DBSetup
    {
        public void Init(Ib190019Context context)
        {
                context.Database.Migrate();
                // Ovde dodajte kod za inicijalizaciju podataka, ako je potrebno
         
           
        }

        public void InsertData(Ib190019Context context)
        {
            var currentDirectory = Directory.GetCurrentDirectory();
            Console.WriteLine("Current Directory: " + currentDirectory);

            var path = Path.Combine(currentDirectory, "Script", "setup.sql");
            Console.WriteLine("Full path to setup.sql: " + path);

            var query = File.ReadAllText(path);
            context.Database.ExecuteSqlRaw(query);
        }
    }
}
