using Oracle.ManagedDataAccess.Client;

namespace SqlConn
{
  class DBUtils
  {

    public static OracleConnection GetDBConnection(string username, string password, string hostname, string port, string serviceName)
    {
      return OracleUtils.GetDBConnection(username, password, hostname, port, serviceName);
    }

  }
}
