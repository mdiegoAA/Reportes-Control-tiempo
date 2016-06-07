using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocios;
using System.Web.Services;

namespace CalendarioReportes_Amezquita
{
    public partial class Index : System.Web.UI.Page
    {

        public static N_Datos N_informacionControlTiempos = new N_Datos();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string obtenerListadoClientes() {
            string rSult = N_informacionControlTiempos.obtenerListadoClientes();
            return rSult;
        
        }

        [WebMethod]
        public static string ObtenerListadoServicioXcliente(string idArchivo) {

            string rSult = N_informacionControlTiempos.ObtenerListadoServicioXcliente(idArchivo);
            return rSult;
        
        }

      
        [WebMethod]
        public static string obtenerMeses_HorasxProyectoxClientexFechaInicio_final(string idProyecto , string idCliente, string fechaInicial , string fechaFinal) {

            string rSult = N_informacionControlTiempos.ListadoMesesxProyectoxServicioxMeses(idProyecto, idCliente, formatoFechas(fechaInicial), formatoFechas(fechaFinal));
            return rSult;

        }

        [WebMethod]
        public static string ReporteTotalfinal(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
        {

           string rSult = N_informacionControlTiempos.SeleccionarMesXrango(idProyecto, idCliente, formatoFechas(fechaInicial), formatoFechas(fechaFinal));
           return rSult;

        }

        [WebMethod]
        public static string SeleccionarMesesXrango(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
        {

            string rSult = N_informacionControlTiempos.SeleccionarMesesXrango(idProyecto, idCliente, formatoFechas(fechaInicial), formatoFechas(fechaFinal));
            return rSult;

        }


       
        [WebMethod]
        public static string traerTiempoxfecha_cargo(string fecha, string idPoryecto, string idServicio)
        {


            string fechaSolicitada = formatoFechas(fecha);
            string rSult = N_informacionControlTiempos.traerTiempoxfecha_cargo(fechaSolicitada, idPoryecto, idServicio);
            return rSult;




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

    }
}