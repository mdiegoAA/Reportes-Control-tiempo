using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using Entidades;

namespace Datos
{
  public  class D_InformacionTiempo:D_Conexion
    {

      int cuenta = 0;
      RegistroTiempos registroTiempo = new RegistroTiempos();


      public string obtenerListadoClientes()
      {

          SqlCommand cmd = new SqlCommand("Sp_Amezquita_obtenerListadoClientes", conn);
          cmd.CommandType = CommandType.StoredProcedure;
     //     cmd.Parameters.AddWithValue("@IdUsuario", id);
          try
          {

              abrirConexion();
              cmd.ExecuteReader();
              
              cerrarConexion();
              SqlDataAdapter das = new SqlDataAdapter(cmd);
              DataTable datasets = new DataTable();
              das.Fill(datasets);
              string data = JsonConvert.SerializeObject(datasets, Formatting.Indented);
              return data;
              

          }
          catch (Exception)
          {
              cerrarConexion();
              throw;
          }


      }


      public DataTable traerEmpleadosxFecha_Cargo(string fecha, string idPoryecto, string idServicio, string cargos)
      {
          string fechaInicial = formatoFechas(fecha);
          fechaInicial = fechaInicial+" 00:00:00";
          string fechaFinal = formatoFechas(fecha);
          fechaFinal = fechaFinal + " 23:59:00";


          SqlCommand cmdArchivos = new SqlCommand("sp_amezquita_traerEmpleadosxFecha_Cargo", conn);
          cmdArchivos.CommandType = CommandType.StoredProcedure;
          cmdArchivos.Parameters.AddWithValue("@fechainicial", fechaInicial);
          cmdArchivos.Parameters.AddWithValue("@fechaFinal", fechaFinal);
          cmdArchivos.Parameters.AddWithValue("@idProyecto", idPoryecto);
          cmdArchivos.Parameters.AddWithValue("@idServicio", idServicio);
          cmdArchivos.Parameters.AddWithValue("@idCargo", cargos);
         


          try
          {
               abrirConexion();
               cmdArchivos.ExecuteReader();
              cerrarConexion();
              SqlDataAdapter da = new SqlDataAdapter(cmdArchivos);
              DataTable dataset = new DataTable();
              da.Fill(dataset);
           //   string data = JsonConvert.SerializeObject(dataset, Formatting.Indented);
            return  dataset;

          }

                  catch (Exception)
                  {
                      cerrarConexion();

                      throw;
                  }

           

           

        

      }

      public string traerTiempoxfecha_cargo(string fecha, string idPoryecto, string idServicio)
      {

          List<RegistroTiempos> registroTiempo = new List<RegistroTiempos>();
          string fechaInicial = formatoFechas(fecha);
          fechaInicial = fechaInicial + " 00:00:00";
          string fechaFinal = formatoFechas(fecha);
          fechaFinal = fechaFinal + " 23:59:00";


          SqlCommand cmdArchivosf = new SqlCommand("sp_amezquita_traerTiempoxfecha_cargo", conn);
          cmdArchivosf.CommandType = CommandType.StoredProcedure;
          cmdArchivosf.Parameters.AddWithValue("@fechainicial", fechaInicial);
          cmdArchivosf.Parameters.AddWithValue("@fechaFinal", fechaFinal);
          cmdArchivosf.Parameters.AddWithValue("@idProyecto", idPoryecto);
          cmdArchivosf.Parameters.AddWithValue("@idServicio", idServicio);



          try
          {
              abrirConexion();
              cmdArchivosf.ExecuteReader();
              cerrarConexion();
              SqlDataAdapter da = new SqlDataAdapter(cmdArchivosf);
              DataTable dataset = new DataTable();
              da.Fill(dataset);
              for (int i = 0; i <= dataset.Rows.Count - 1; i++)
              {

                  RegistroTiempos NewRegistroTimpo =new  RegistroTiempos();
                  NewRegistroTimpo.tiempo = dataset.Rows[i].ItemArray[0].ToString();
                  NewRegistroTimpo.nombre = dataset.Rows[i].ItemArray[1].ToString();
                  NewRegistroTimpo.idCargo = dataset.Rows[i].ItemArray[2].ToString();
                  NewRegistroTimpo.estado = "1";
                  registroTiempo.Add(NewRegistroTimpo);
              }

              for (int j = 0; j <= dataset.Rows.Count - 1; j++)
              {
                  DataTable datasetd = new DataTable();
                  string descripcionCuentas = (dataset.Rows[j].ItemArray[2].ToString());
                  datasetd = traerEmpleadosxFecha_Cargo(fechaInicial, idPoryecto, idServicio, descripcionCuentas);
                  for (int h = 0; h <= datasetd.Rows.Count - 1; h++)
                  {

                      RegistroTiempos cargosEmpleo = new RegistroTiempos();
                      cargosEmpleo.tiempo = datasetd.Rows[h].ItemArray[0].ToString();
                      cargosEmpleo.nombre = datasetd.Rows[h].ItemArray[1].ToString();
                      cargosEmpleo.idCargo = datasetd.Rows[h].ItemArray[2].ToString();
                      cargosEmpleo.estado = "2";
                      registroTiempo.Add(cargosEmpleo);
                  
                  }


                
              
              }

              string data = JsonConvert.SerializeObject(registroTiempo, Formatting.Indented);
              return data;

          }

          catch (Exception)
          {
              cerrarConexion();
              throw;
          }







      }

      public string SeleccionarMesesXrango(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
      {
          cuenta = 0;
          SqlCommand cmdArchivos = new SqlCommand("sp_Amezquita_SeleccionarMesXrango", conn);
          cmdArchivos.CommandType = CommandType.StoredProcedure;
          cmdArchivos.Parameters.AddWithValue("@fechaInicio", fechaInicial);
          cmdArchivos.Parameters.AddWithValue("@fechaFinal", fechaFinal);
          cmdArchivos.Parameters.AddWithValue("@idProyecto", idProyecto);
          cmdArchivos.Parameters.AddWithValue("@idServicio", idCliente);


          try
          {

              abrirConexion();
              cmdArchivos.ExecuteReader();
              cerrarConexion();
              SqlDataAdapter da = new SqlDataAdapter(cmdArchivos);
              DataTable dataset = new DataTable();
              da.Fill(dataset);
              string data = JsonConvert.SerializeObject(dataset, Formatting.Indented);
              return data;

          }
          catch (Exception e)
          {



              return "Problemas con la ecuacion";
          }
      }

      public string ListadoMesesxProyectoxServicioxMeses(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
      {


          List<E_RegistroTiempo> listRegistroTiempo = new List<E_RegistroTiempo>();

          SqlCommand cmdArchivos = new SqlCommand("Sp_Amezquita_ListadoMesesxProyectoxServicioxMeses", conn);
          cmdArchivos.CommandType = CommandType.StoredProcedure;
          cmdArchivos.Parameters.AddWithValue("@fechainicial", fechaInicial);
          cmdArchivos.Parameters.AddWithValue("@fechaFinal", fechaFinal);
          cmdArchivos.Parameters.AddWithValue("@proyectoId", idProyecto);
          cmdArchivos.Parameters.AddWithValue("@ServicioId", idCliente);


          try
          {
              abrirConexion();
              cmdArchivos.ExecuteReader();
              cerrarConexion();

              SqlDataAdapter da = new SqlDataAdapter(cmdArchivos);
              DataTable dataset = new DataTable();
              da.Fill(dataset);
              

              for (int i = 0; i <= dataset.Rows.Count - 1; i++)
              {
                  string data = "";
                  string descripcionCuentas = formatoFechas(dataset.Rows[i].ItemArray[0].ToString());
                  descripcionCuentas = descripcionCuentas + " 00:00:00";

                  string descripcionSiguiente = formatoFechas(dataset.Rows[i].ItemArray[0].ToString());
                  descripcionSiguiente = descripcionSiguiente + " 23:59:00";

                  SqlCommand cmdArchivosMinutos = new SqlCommand("Sp_Amezquita_ObtenerMinutosxMesesxProyectoxServicioxMeses", conn);
                  cmdArchivosMinutos.CommandType = CommandType.StoredProcedure;
                  cmdArchivosMinutos.Parameters.AddWithValue("@fechainicial", descripcionCuentas);
                  cmdArchivosMinutos.Parameters.AddWithValue("@fechaFinal", descripcionSiguiente);
                  cmdArchivosMinutos.Parameters.AddWithValue("@proyectoId", idProyecto);
                  cmdArchivosMinutos.Parameters.AddWithValue("@ServicioId", idCliente);

                  try
                  {
                       abrirConexion();
                       SqlDataReader rdr = cmdArchivosMinutos.ExecuteReader();
                        rdr.Read();
                        data = rdr["minutos"].ToString();
                        rdr.Close();
                       cerrarConexion();

                        E_RegistroTiempo registroTiempo = new E_RegistroTiempo();
                        registroTiempo.fecha = formatoFechasReturn(descripcionCuentas);
                        registroTiempo.tiempo = formatosminutoHoras(data);
                        listRegistroTiempo.Add(registroTiempo);

                       
                  }

                  catch (Exception)
                  {
                      
                      throw;
                  }
              
              }

              string datas = JsonConvert.SerializeObject(listRegistroTiempo, Formatting.Indented);
              return datas;

          }

          catch (Exception)
          {
              cerrarConexion();
              throw;
          }


      }

      public string SeleccionarMesXrango(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
      {
          cuenta = 0;
          SqlCommand cmdArchivos = new SqlCommand("sp_Amezquita_SeleccionarMesXrango", conn);
          cmdArchivos.CommandType = CommandType.StoredProcedure;
          cmdArchivos.Parameters.AddWithValue("@fechaInicio", fechaInicial);
          cmdArchivos.Parameters.AddWithValue("@fechaFinal", fechaFinal);
          cmdArchivos.Parameters.AddWithValue("@idProyecto", idProyecto);
          cmdArchivos.Parameters.AddWithValue("@idServicio", idCliente);


          try
          {
          
              abrirConexion();
              cmdArchivos.ExecuteReader();
              cerrarConexion();
              SqlDataAdapter das = new SqlDataAdapter(cmdArchivos);
              DataTable datasete = new DataTable();
              das.Fill(datasete);

              string Rsult="";
              string alias = "";

              for (int i = 0; i <= datasete.Rows.Count - 1; i++)
              {

                  if (i == datasete.Rows.Count - 1)
                  {

                      Rsult = Rsult + formatoFechaQueryUltimo(datasete.Rows[i].ItemArray[0].ToString());
                      alias = alias + formatoFechaQueryAliasUltimo(datasete.Rows[i].ItemArray[0].ToString());

                  }
                  else
                  {


                      Rsult = Rsult + formatoFechaQuery(datasete.Rows[i].ItemArray[0].ToString());
                      alias = alias + formatoFechaQueryAlias(datasete.Rows[i].ItemArray[0].ToString());
                  }
              }

              SqlConnection sql = new SqlConnection(ConfigurationManager.ConnectionStrings["CT_pruebasConnectionString"].ConnectionString);
              SqlCommand cmds = new SqlCommand();
              SqlDataReader reader;

              string query = "with reporteTiempo (minutos,fecha , nombre , cargo ) as ( ";
              query = query + "SELECT distinct SUM((datediff(N,ch.FechaInicio,ch.FechaFin))) as Minutos ,CAST(ch.FechaInicio as Date) as fecha, us.Nombre , c.NombreCargo ";
              query = query + "FROM CarguesHoras ch , Usuarios us , Cargos c where ";
              query = query + "ch.ProyectoId = '" + idProyecto + " '";
              query = query + "and ch.ServicioId = '"+idCliente+" '";
              query = query + "and ch.FechaInicio BETWEEN '"+fechaInicial+"' AND '"+fechaFinal+" '";
              query = query + "and  c.CargoId = us.CargoId ";
              query = query + "and us.UsuarioId = ch.UsuarioId ";
              query = query + "GROUP BY  CAST(ch.FechaInicio as Date) , us.Nombre , c.NombreCargo) ";
              query = query + "select nombre , cargo , " + alias + " from reporteTiempo ";
              query = query + "pivot (sum(minutos) for fecha in("+Rsult+")) PVT ";
              query = query + "order by cargo ";




              cmds.CommandText = query;
              cmds.CommandType = CommandType.Text;
              cmds.Connection = sql;
              
              try
              {

                  sql.Open();
                  cmds.ExecuteReader();
                  sql.Close();
                  SqlDataAdapter da = new SqlDataAdapter(cmds);
                  DataTable dataset = new DataTable();
                  da.Fill(dataset);
                  string data = JsonConvert.SerializeObject(dataset, Formatting.Indented);
                  return data;

              }
              catch (Exception e)
              {



                  return "Problemas con la ecuacion";
              }



           

          }

          catch (Exception)
          {
              cerrarConexion();
              throw;
          }


      }

      public string ObtenerMinutosxMesesxProyectoxServicioxMeses(string date) {

          DateTime diaSiguiente = Convert.ToDateTime(date);
          diaSiguiente = diaSiguiente.AddDays(1);
          string diaSiguienteFecha = formatoFechas(diaSiguiente.ToString());

          return diaSiguienteFecha;


         
      }

      public string ObtenerListadoServicioXcliente(string idArchivo)
      {

          SqlCommand cmdArchivos = new SqlCommand("Sp_Amezquita_ObtenerListadoServicioXcliente", conn);
          cmdArchivos.CommandType = CommandType.StoredProcedure;
          cmdArchivos.Parameters.AddWithValue("@idProyecto", idArchivo);
         


          try
          {


              abrirConexion();
              cmdArchivos.ExecuteReader();
              cerrarConexion();
              SqlDataAdapter da = new SqlDataAdapter(cmdArchivos);
              DataTable dataset = new DataTable();
              da.Fill(dataset);
              string data = JsonConvert.SerializeObject(dataset, Formatting.Indented);
              return data;

          }

          catch (Exception)
          {
              cerrarConexion();
              return "";
          }


      }

      public static string formatoFechas(string fecha)
      {


          DateTime fechaDatatime = Convert.ToDateTime(fecha);
          int dayDatatime = fechaDatatime.Day;
          int mesDatatime = fechaDatatime.Month;
          int yearDatatime = fechaDatatime.Year;
          string dayReturn = "";
          string mesReturn = "";

          if (dayDatatime <= 9)
          {
              dayReturn = "0" + dayDatatime;

          }
          else
          {

              dayReturn = dayDatatime.ToString();

          }


          if (mesDatatime <= 9)
          {
              mesReturn = "0" + mesDatatime;
          }
          else
          {
              mesReturn = mesDatatime.ToString();
          }

          string fechaInicialBusqueda = dayReturn + "/" + mesReturn + "/" + yearDatatime;
         

          return fechaInicialBusqueda;

      }
      public static string formatoFechasReturn(string fecha)
      {


          DateTime fechaDatatime = Convert.ToDateTime(fecha);
          int dayDatatime = fechaDatatime.Day;
          int mesDatatime = fechaDatatime.Month;
          int yearDatatime = fechaDatatime.Year;
          string dayReturn = "";
          string mesReturn = "";

          if (dayDatatime <= 9)
          {
              dayReturn = "0" + dayDatatime;

          }
          else
          {

              dayReturn = dayDatatime.ToString();

          }


          if (mesDatatime <= 9)
          {
              mesReturn = "0" + mesDatatime;
          }
          else
          {
              mesReturn = mesDatatime.ToString();
          }

          string fechaInicialBusqueda = mesReturn + "/" + dayReturn + "/" + yearDatatime;
        


          return fechaInicialBusqueda;

      }
      public string formatosminutoHoras(string minutos) {

          string HorasTotal = (Convert.ToInt64(minutos) / 60).ToString();
          string MinutosTotal = (Convert.ToInt64(minutos) % 60).ToString();

          return HorasTotal + ":" + MinutosTotal;
      }
      public string formatoFechaQuery(string fechas) {

          string palabra = fechas;          
          int numero = palabra.IndexOf(" ");
          palabra = palabra.Substring(0,numero);
          palabra = "[" + palabra + "],";
          return palabra;
      
      }
      public string formatoFechaQueryAlias(string fechas)
      {
          cuenta = cuenta + 1;
          string palabra = fechas;
          int numero = palabra.IndexOf(" ");
          palabra = palabra.Substring(0, numero);
          palabra = " ISNULL([" + palabra + "],0) as  column" + cuenta + ",";
          return palabra;

      }
      public string formatoFechaQueryAliasUltimo(string fechas)
      {
          cuenta = cuenta + 1;
          string palabra = fechas;
          int numero = palabra.IndexOf(" ");
          palabra = palabra.Substring(0, numero);
          palabra = " ISNULL([" + palabra + "],0) as  column" + cuenta;
          return palabra;

      }
      public string formatoFechaQueryUltimo(string fechas)
      {

          string palabra = fechas;
          int numero = palabra.IndexOf(" ");
          palabra = palabra.Substring(0, numero);
          palabra = "[" + palabra + "]";
          return palabra;

      }


    }
}
