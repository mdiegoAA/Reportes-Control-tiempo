using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Datos
{
    public class D_Conexion
    {
        public SqlConnection conn = new SqlConnection();


        public D_Conexion()
        {

            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CT_pruebasConnectionString"].ConnectionString);


        }

        public void abrirConexion()
        {

            if (conn.State == ConnectionState.Broken || conn.State == ConnectionState.Closed)
            {

                try
                {
                    conn.Open();
                }
                catch (Exception e)
                {

                    throw new Exception("Problemas conectar base Datos ", e);
                }

            }

        }

        public void cerrarConexion()
        {

            if (conn.State == ConnectionState.Open)
            {
                try
                {
                    conn.Close();
                }
                catch (Exception)
                {

                    throw;
                }
            }


        }



    }
}
