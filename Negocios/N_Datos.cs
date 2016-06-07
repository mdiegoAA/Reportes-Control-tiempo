using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Datos;

namespace Negocios
{
  public  class N_Datos
    {

        public D_InformacionTiempo informacionControlTiempos = new  D_InformacionTiempo();

        public string obtenerListadoClientes()
        {

            return informacionControlTiempos.obtenerListadoClientes();
        
        }

        public string ObtenerListadoServicioXcliente(string idArchivo) 
        {

            return informacionControlTiempos.ObtenerListadoServicioXcliente(idArchivo);

        }

        public string ListadoMesesxProyectoxServicioxMeses(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
        {

            return informacionControlTiempos.ListadoMesesxProyectoxServicioxMeses(idProyecto, idCliente, fechaInicial, fechaFinal);
        
        }

      
        public string traerTiempoxfecha_cargo(string fecha, string idPoryecto, string idServicio)
        {

            return informacionControlTiempos.traerTiempoxfecha_cargo(fecha, idPoryecto, idServicio);

        }

        public string SeleccionarMesXrango(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
        {

            return informacionControlTiempos.SeleccionarMesXrango(idProyecto,idCliente,fechaInicial, fechaFinal);

        }
        public string SeleccionarMesesXrango(string idProyecto, string idCliente, string fechaInicial, string fechaFinal)
        {

            return informacionControlTiempos.SeleccionarMesesXrango(idProyecto,idCliente,fechaInicial,fechaFinal);
        
        }

    }
}
