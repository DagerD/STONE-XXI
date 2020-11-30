using Oracle.ManagedDataAccess.Client;
using SqlConn;
using System;

namespace STONE_XXI
{
  class Program
  {

    static void Main(string[] args)
    {

      if (args.Length == 5)
      {
        connectToDB(args[0], args[1], args[2], args[3], args[4]);
      } else
      {
        Console.WriteLine("Введены не все данные для подключения");
        Console.WriteLine("\nДля закрытия программы нажмите любую кнопку на клавиатуре");
        Console.ReadKey();
        return;
      }

    }

    private static void connectToDB(string username, string password, string hostname, string port, string serviceName)
    {

      OracleConnection conn = DBUtils.GetDBConnection(username, password, hostname, port, serviceName);

      try
      {
        conn.Open();
      } catch (OracleException err) 
      {
        Console.WriteLine("Ошибка подключения к БД\n:");
        Console.WriteLine(err);
        Console.WriteLine("\nДля закрытия программы нажмите любую кнопку на клавиатуре");
        Console.ReadKey();
        return;
      }

      Console.WriteLine("Connected to Oracle" + conn.ServerVersion);

      int day = 28;
      int month = 11;
      int year = 2020;
      string date = new DateTime(year, month, day).ToString("dd/MM/yyyy");

      string currency = "XDR";

      double dr = OracleUtils.getCurrencyOnDate(conn, date, currency);

      if (dr != -1)
      {
        Console.WriteLine(dr);
      } else
      {
        Console.WriteLine("Запрос не вернул данные, проверьте параметры");
      }

      conn.Close();
      conn.Dispose();

      Console.WriteLine("Для закрытия программы нажмите любую кнопку на клавиатуре");
      Console.ReadKey();
    }

    
  }
}
