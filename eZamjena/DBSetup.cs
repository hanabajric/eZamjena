using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;

namespace eZamjena
{
    public class DBSetup
    {
        public void Init(Ib190019Context context)
        {
                context.Database.Migrate();
               
        }

        public void InsertData(Ib190019Context context)
        {
            var currentDirectory = Directory.GetCurrentDirectory();
            Console.WriteLine("Current Directory: " + currentDirectory);

             var path = Path.Combine(currentDirectory, "Script", "script_new.sql");
            //var path = Path.Combine("/app", "Script", "script2.sql");
            Console.WriteLine("Full path to setup.sql: " + path);

            var query = File.ReadAllText(path);
            context.Database.ExecuteSqlRaw(query);
        }
    }
}
