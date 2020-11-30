using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace SqlConn
{

  public class OracleUtils
  {

    public static OracleConnection GetDBConnection(string username, string password, string hostname, string port, string serviceName)
    {
      OracleConnection conn = new OracleConnection();
      // "User Id=<username>;Password=<password>;Data Source=<hostname:port/serviceName>";
      conn.ConnectionString = String.Concat("User Id=", username, ";Password=", password, ";Data Source=", hostname, ':', port, '/', serviceName);

      return conn;
    }
    public static double getCurrencyOnDate(OracleConnection conn, string date, string currency)
    {
      string query = "select t.value " +
                       "from FOREIGN_CURRENCY_MARKET t " +
                      "where t.on_date = :p_date " +
                        "and t.charcode = :p_currency_charcode ";

      OracleParameter p_date = new OracleParameter
      {
        OracleDbType = OracleDbType.Varchar2,
        Value = date
      };

      OracleParameter p_currency = new OracleParameter
      {
        OracleDbType = OracleDbType.Varchar2,
        Value = currency
      };

      OracleCommand cmd = new OracleCommand(query, conn);
      cmd.CommandType = CommandType.Text;
      cmd.Parameters.Add(p_date);
      cmd.Parameters.Add(p_currency);

      //OracleDataReader dr = cmd.ExecuteReader();
      object result = cmd.ExecuteScalar();

      if (result != null)
      {
        return Convert.ToDouble(result);
      } else // -1 потому что курс валют не может быть отрицательным
      {
        return -1;
      }
      
    }

  }
}