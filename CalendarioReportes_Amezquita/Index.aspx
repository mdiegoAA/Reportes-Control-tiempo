<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CalendarioReportes_Amezquita.Index" %>

<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8' />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<link href="fullcalendar.css" rel='stylesheet' />
<link href="fullcalendar.print.css" rel='stylesheet' media='print' />
<script src="moment.min.js"></script>
<script src="fullcalendar.min.js"></script>
<script src="js/bootstrap.min.js"></script>
 
<!-- Latest compiled and minified CSS -->

    <link href="bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="bower_components/metisMenu/dist/metisMenu.min.css" rel="stylesheet">
    <link href="dist/css/sb-admin-2.css" rel="stylesheet">    
    <link href="bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/bootstrap-select.min.js"></script>

<!-- (Optional) Latest compiled and minified JavaScript translation files -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/i18n/defaults-*.min.js"></script>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="js/jquery.table2excel.js"></script>
<link href="css/introLoader.min.css" rel="stylesheet" />
<script src="js/jquery.introLoader.pack.min.js"></script>   

<style type="text/css">
    .modal-body {
    max-height: 1000px;
}

</style>

<link href="css/bootstrap.min.css" rel="stylesheet">
      <script>
          $(function () {
              $("#datepicker").datepicker({
                  changeMonth: true,
                  changeYear: true,
                  changeDay: true,
                  showButtonPanel: true,
                  dateFormat: 'yy-mm-dd',
                  onClose: function (dateText, inst) {
                      var day = $("#ui-datepicker-div .ui-datepicker-day :selected").val();
                      var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                      var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                      $('#startDate').datepicker({ defaultDate: -30 });
                      $('#endDate').datepicker({ defaultDate: new Date() });
                  }
              });
          });
    </script>
<script>

    var idcliente;

    $(document).ready(function () {
       
        $("#element").introLoader();
        CargarListadoClientes();
        var generarReporte = $("#generarReporte");
        generarReporte.click(function () {
            DescargarDocumento();

        });

        var Reporte = $("#Reporte");
        Reporte.click(function () {
            ReporteMeseTiempo();
           
           
        });
        var Tree = $("#Tree");
        Tree.click(function () {

            var Modaltree = $("#Modaltree");
            Modaltree.modal("show");

        });

        var Consultar = $("#Consultar");
      
        Consultar.click(function () {

         

            var proyectoId = $("#ListadoClientes option:selected").val();
            var clienteId = $("#serviciosCliente option:selected").val();
            var fechaInicial = $("#datepicker").val();
            var fechaFinal = $("#datepicker2").val();

            var data =
                {
                    idProyecto: proyectoId,
                    idCliente: clienteId,
                    fechaInicial: fechaInicial,
                    fechaFinal: fechaFinal
                }
            $.ajax({

                url: "Index.aspx/obtenerMeses_HorasxProyectoxClientexFechaInicio_final",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(data),
                dataType: "json",

                success: function (result) {

                    EliminarEventosCalendario();

                    var data = JSON.parse(result.d);
                    for (var i = 0; i < data.length - 1; i++) {

                        var fecha = data[i].fecha;
                        var title = data[i].tiempo;

                        agregarEvento(title, fecha);

                    }


                }
            });
        });


        var ListadoClientes = $("#ListadoClientes");
        ListadoClientes.click(function () {

            var rSultIdArchivo = $("#ListadoClientes option:selected").val();
            var data =
            {
                idArchivo: rSultIdArchivo

            }

            $.ajax({

                url: "Index.aspx/ObtenerListadoServicioXcliente",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(data),
                dataType: "json",

                success: function (result) {

                
                    var data = JSON.parse(result.d);
                    var temp = "";
                    for (var i = 0; i < data.length; i++) {

                        temp += "<option value=" + data[i].ServicioId + ">" + LimpiarNombreCliente(data[i].NombreServicio) + "</option>";

                    }

                    var serviciosCliente = $("#serviciosCliente");
                    serviciosCliente.empty();
                    serviciosCliente.append(temp);

                }
            });





        });


        var selectP = $("#selectP");
        selectP.change(function () {


            alert("Pruebva");

        });



        $('.selectpicker').selectpicker({
            style: 'btn-info',
            size: 4
        });


        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                // right: 'month,basicWeek,basicDay'
            },
            defaultDate: '2016-05-12',
            //   editable: true,
            eventLimit: true, // allow "more" link when too many events
            events: [


            ],
            eventClick: function (event) {

                console.log(event);

                var TitleReporte = $("#TitleReporte");
                TitleReporte.empty();
                var R = event.start._i;

                
                var d = formatoFecha(R);
                var ds = "<a class='text-left'>Reporte del dia " + d + "</a>";
                ds += "<a class='text-right'><span class='badge'>"+event.title+"</span></a>";
             
                // alert(fechaFormatos);
                TitleReporte.append(ds);
              
               // TitleReporte.text("Reporte del dia " + d + event.title);
                //  console.log(event.start._i);

          
                
               traerTiempoxfecha_cargo(d);

                
             
       //       traerEmpleadosxFecha_Cargo(d);


               var modalReporte = $("#modalReporte");
               modalReporte.modal("show");

            }
        });


        // agregarEvento();


    });

    function DescargarDocumento() {
        var datepicker = $("#datepicker").val();
        var datepicker2 = $("#datepicker2").val();

        var proyectoId = $("#ListadoClientes option:selected").text();
        var servicioId = $("#serviciosCliente option:selected").text();
        var ReporteProyecto = $("#ReporteProyecto");
        var ReporteServicio = $("#ReporteServicio");
        var ReporteFechaInicio = $("#ReporteFechaInicio");
        var ReporteFechaFinal = $("#ReporteFechaFinal");
        ReporteFechaFinal.text(datepicker2);
        ReporteFechaInicio.text(datepicker);
        ReporteServicio.text(servicioId);
        ReporteProyecto.text(proyectoId);

        $("#ReporteDiario").table2excel({

            // exclude CSS class

            exclude: ".noExl",
            name: "Prueba.xls",
            filename: "Reporte"

        });



    }

    function ReporteMeseTiempo() {
        var ReporteFechaInicio = $("#ReporteFechaInicio");
        var proyectoId = $("#ListadoClientes option:selected").val();
        var clienteId = $("#serviciosCliente option:selected").val();
        var fechaInicial = $("#datepicker").val();
        var fechaFinal = $("#datepicker2").val();

        var data =
            {
                idProyecto: proyectoId,
                idCliente: clienteId,
                fechaInicial: fechaInicial,
                fechaFinal: fechaFinal
            }
        $.ajax({

            url: "Index.aspx/SeleccionarMesesXrango",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (result) {
           

                var data = JSON.parse(result.d);

                var temp="";
                temp += "<tr>";

               temp += "<th>Nombre</th>";
               temp += "<th>Cargo</th>";

                for (var i = 0; i < data.length; i++) {

                    temp += "<th>" + formatoFechas(data[i].fecha) + "</th>";

                }

                temp += "</tr>";
              //  console.log(temp);

                var Cabezera = $("#Cabezera");
                Cabezera.empty();
                Cabezera.append(temp);
                ReporteTotalTiempo();
              


                }
        });
    }

    function formatoFechas(data) {

        var fecha = data;
        var f = (fecha.indexOf("T"));
        var Rsult = fecha.substring(0,f);
        return Rsult;



    }

	function ReporteTotalTiempo (){
		
	    var proyectoId = $("#ListadoClientes option:selected").val();
	    var clienteId = $("#serviciosCliente option:selected").val();
	    var fechaInicial = $("#datepicker").val();
	    var fechaFinal = $("#datepicker2").val();

	    var data =
            {
                idProyecto: proyectoId,
                idCliente: clienteId,
                fechaInicial: fechaInicial,
                fechaFinal: fechaFinal
            }
	    $.ajax({

	        url: "Index.aspx/ReporteTotalfinal",
	        type: "POST",
	        contentType: "application/json; charset=utf-8",
	        data: JSON.stringify(data),
	        dataType: "json",
	        success: function (result) {

	         

	            var data = JSON.parse(result.d);
	            var temp = "";
	            var variableAux = "data[i].02/05/2016";
	       
	           

	            for (var i = 0; i < data.length; i++) {
	                temp += "<tr>";
                  
	                temp += "<td>" + data[i].nombre + "</td>";
	                temp += "<td>" + data[i].cargo + "</td>";

	                if (data[i].column1 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column1) + "</td>";
	                }

	                if (data[i].column2 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column2) + "</td>";
	                }

	                if (data[i].column3 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column3)+ "</td>";
	                }

	                if (data[i].column4 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column4) + "</td>";
	                }

	                if (data[i].column5 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column5) + "</td>";
	                }
	                if (data[i].column6 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column6) + "</td>";
	                }
	                if (data[i].column7 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column7) + "</td>";
	                }
	                if (data[i].column8 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column8) + "</td>";
	                }
	                if (data[i].column9 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column9) + "</td>";
	                }
	                if (data[i].column10 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column10) + "</td>";
	                }
	                if (data[i].column11 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column11) + "</td>";
	                }
	                if (data[i].column12 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column12) + "</td>";
	                }
	                if (data[i].column13 != null) {
	                    temp += "<td>" +reescribirFecha(data[i].column13) + "</td>";
	                }
	                if (data[i].column14 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column14) + "</td>";
	                }
	                if (data[i].column15 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column15) + "</td>";
	                }
	                if (data[i].column16 != null) {
	                    temp += "<td>" +reescribirFecha(data[i].column16) + "</td>";
	                }
	                if (data[i].column17 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column17) + "</td>";
	                }
	                if (data[i].column18 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column18) + "</td>";
	                }
	                if (data[i].column19 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column19) + "</td>";
	                }
	                if (data[i].column20 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column20) + "</td>";
	                }
	                if (data[i].column21 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column21) + "</td>";
	                }
	                if (data[i].column22 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column22) + "</td>";
	                }
	                if (data[i].column23 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column23) + "</td>";
	                }
	                if (data[i].column24 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column24) + "</td>";
	                }
	                if (data[i].column25 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column25) + "</td>";
	                }
	                if (data[i].column26 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column26) + "</td>";
	                }
	                if (data[i].column27 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column27) + "</td>";
	                }
	                if (data[i].column28 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column28) + "</td>";
	                }
	                if (data[i].column29 != null) {
	                    temp += "<td>" +reescribirFecha(data[i].column29) + "</td>";
	                }
	                if (data[i].column30 != null) {
	                    temp += "<td>" + reescribirFecha(data[i].column30) + "</td>";
	                }
	                if (data[i].column31 != null) {
	                    temp += "<td>" +reescribirFecha(data[i].column31) + "</td>";
	                }
	                if (data[i].column32 != null) {
	                    temp += "<td>" +reescribirFecha(data[i].column32) + "</td>";
	                }


	                temp += "</tr>";

	            }
	          
	            temp += "</table>";

	            var rSultQuery = $("#rSultQuery");
	            rSultQuery.empty();
	            rSultQuery.append(temp);
	         //   ReporteMeseTiempo();
	         
	            var modalRsult = $("#modalRsult");
	            modalRsult.modal("show");




	        }
	    });



		

	}

	function reescribirFecha(data) {

	    var fecha = parseInt(data);
	    var hora = parseInt(fecha / 60);
	    var minutos = (fecha % 60);	   
	    var result = hora + ":" + minutos;

	    return result;

	}

    function traerTiempoxfecha_cargo(fecha) {

        var proyectoId = $("#ListadoClientes option:selected").val();
        var clienteId = $("#serviciosCliente option:selected").val();
        var diaSolicitado = fecha;
        
        var data =
          {
              fecha: diaSolicitado,
              idPoryecto: proyectoId,
              idServicio: clienteId

          }

        $.ajax({

            url: "Index.aspx/traerTiempoxfecha_cargo",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(data),
            dataType: "json",

            success: function (result) {

              
               
                var data = JSON.parse(result.d);

                var accordion = $("#accordion");
                accordion.empty();

                for (var i = 0; i < data.length; i++) {

                  

                    if (data[i].estado == "1") {

                        var codigo = data[i].idCargo;
                        var tempS = "";
                        tempS += "<table class='table'>";
                        tempS += "<th>";
                        tempS += "Nombre";
                        tempS += "</th>";
                        tempS += "<th>";
                        tempS += "Tiempo";
                        tempS += "</th>";
                        tempS += "</tr>";

                        for (var j = 0; j < data.length; j++) {

                            if (data[j].estado == "2" && data[j].idCargo == codigo) {

                                var horas = parseInt((data[j].tiempo) / 60);
                                var MinutosR = parseInt((data[j].tiempo) % 60);
                                var TiempoCargado = horas.toString() + ":" + MinutosR.toString();
                               
                                tempS += "<tr>";
                                tempS += "<td>";
                                tempS += data[j].nombre;
                                tempS += "</td>";
                                tempS += "<td>";
                                tempS += TiempoCargado;
                                tempS += "</td>";
                                tempS += "<tr>";
                               

                            }

                        }

                        tempS += "</table>";
                        var temp = "";
                        var horas = parseInt((data[i].tiempo) / 60);
                        var MinutosR = parseInt((data[i].tiempo) % 60);
                        var TiempoCargado = horas.toString() + ":" + MinutosR.toString();

                        temp += "<div class='panel panel-default'>";
                        temp += "<div class='panel-heading' role='tab' id='headingOne'>";
                        temp += "<h4 class='panel-title'>";
                        temp += "<a role='button' data-toggle='collapse' data-parent='#accordion' href='#collapseOnePrueba" + i + "' aria-expanded='true' aria-controls='collapseOne'>";
                        temp += "<div ><i class='fa fa-user' aria-hidden='true'></i>" + data[i].nombre + "</a><a class='text-right'><span class='badge'>" + "   " + TiempoCargado + "</div>";
                        temp += "</a>";
                        temp += "</h4>";
                        temp += "</div>";
                        temp += "<div id='collapseOnePrueba" + i + "'  class='panel-collapse collapse' role='tabpanel' aria-labelledby='headingOne'>";
                        temp += "<div class='panel-body'>";
                        temp += tempS;
                        temp += "</div>";
                        temp += "</div>";
                        temp += "</div>";
                        accordion.append(temp);



                    }
                 
             

                }


            }

        });

    }

    function myfunction(data) {

       

    }


    function agregarEventos(idEvento, fecha) {

    
        
        var proyectoId = $("#ListadoClientes option:selected").val();
        var clienteId = $("#serviciosCliente option:selected").val();
        var diaSolicitado = fecha;
        var idCargo = idEvento;
        var rsult;
    
        var data =
          {
              fecha: diaSolicitado,
              idPoryecto: proyectoId,
              idServicio: clienteId,
              idCargo:idCargo
          }

        $.ajax({

            url: "Index.aspx/traerEmpleadosxFecha_Cargo",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(data),
            dataType: "json",

            success: function (result) {

             

                var data = JSON.parse(result.d);
                var temp = "";

                for (var i = 0; i < data.length; i++) {
                    temp += "<table>";
                    temp += "<tr>";
                    temp += "<td>" + data[i].nombre + "</td>";
                    temp += "<td>" + data[i].Minutos + "</td>";
                    temp += "</tr>";
                    temp += "</table>";

                }

            
               
            }

        });

      //  alert(rsult);

        return rsult;
        

    }

    function myFunction() {

        alert("sdasd");

    }

    function traerEmpleadosxFecha_Cargo(fecha) {

        var proyectoId = $("#ListadoClientes option:selected").val();
        var clienteId = $("#serviciosCliente option:selected").val();
        var diaSolicitado = fecha;

        var data =
          {
              fecha: diaSolicitado,
              idPoryecto: proyectoId,
              idServicio: clienteId

          }

        $.ajax({

            url: "Index.aspx/traerEmpleadosxFecha_Cargo",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(data),
            dataType: "json",

            success: function (result) {
                
                var data = JSON.parse(result.d);
               
                alert(result.d);
                for (var i = 0; i < data.length; i++) {

                    var rsultCargo = $("#" + data[i].Cargo + "");
                    rsultCargo.append(data[i].nombre);


                }
            

            }
    });



    }

    function formatoFecha(fecha) {

        var date = new Date(fecha);
       



        var año = moment(date).format('YYYY');
        var mes = moment(date).format('MM');
        var day = moment(date).format('DD');

        var Rsult = año +"-"+mes+"-"+day;
        
        return Rsult;
       
    }

    function CargarListadoClientes() {
        $("#element").introLoader();
        $.ajax({
            url: "Index.aspx/obtenerListadoClientes",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {

                var data = JSON.parse(result.d);
                var temp = "";

                temp += "<select  class='selectpicker form-control' data-live-search='true' title='Seleccione un cliente ...'>";
   
                for (var i = 0; i < data.length; i++)
                {
                    temp += "<option value=" + data[i].ProyectoId + ">" + LimpiarNombreCliente(data[i].NombreProyecto) + "</option>";
                }

                temp += "</select>";

                var ListadoClientes = $("#ListadoClientes");
               ListadoClientes.append(temp);
               
             
            }
        });
    }

    function agregarEvento(title, fecha) {


        var myCalendar = $('#calendar');
        myCalendar.fullCalendar();
        var d = new Date(fecha);
        var myEvent = {
            title: title,
            allDay: true,
            start: d
            // end: new Date()
        };
        myCalendar.fullCalendar('addResource', myEvent)
      //  myCalendar.fullCalendar('addEventSource', myEvent);
        myCalendar.fullCalendar('renderEvent', myEvent,true);

    }

    function EliminarEventosCalendario() {


        var myCalendar = $('#calendar');
        myCalendar.fullCalendar();      
     
        myCalendar.fullCalendar('removeEvents')
        //  myCalendar.fullCalendar('addEventSource', myEvent);
      

    }



    function LimpiarNombreCliente(data) {

        var dataInformacion = data.indexOf("-");
        var rsult;
        rsult = data.substring(dataInformacion + 1, data.length);
        return rsult;



    }



</script>
   <script>
       $(function () {
           $("#datepicker").datepicker({
               changeMonth: true,
               changeYear: true,
               changeDay: true,
               showButtonPanel: true,
               dateFormat: 'yy-mm-dd',
               onClose: function (dateText, inst) {
                   var day = $("#ui-datepicker-div .ui-datepicker-day :selected").val();
                   var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                   var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                   $('#startDate').datepicker({ defaultDate: -30 });
                   $('#endDate').datepicker({ defaultDate: new Date() });
               }
           });
       });
    </script>
     <script>
         $(function () {
             $("#datepicker2").datepicker({
                 changeMonth: true,
                 changeYear: true,
                 changeDay: true,
                 showButtonPanel: true,
                 dateFormat: 'yy-mm-dd',
                 onClose: function (dateText, inst) {
                     var day = $("#ui-datepicker-div .ui-datepicker-day :selected").val();
                     var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                     var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                     $('#startDate').datepicker({ defaultDate: -30 });
                     $('#endDate').datepicker({ defaultDate: new Date() });
                 }
             });
         });
    </script>
<style>

	body {
		margin: 40px 10px;
		padding: 0;
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
		font-size: 14px;
	}

	#calendar {
		max-width: 900px;
		margin: 0 auto;
	}

</style>
</head>
<body>
    <div id="element" class="introLoading"></div>
    <div class="container">
    <div class="row">
         <div class="col-md-1">
        </div>
         <div class="col-md-4">
            <img src="http://www.amezquita.com.co/wp-content/uploads/2015/03/Logo-en-Policrom--a-e1443198604156.png"  width="314" height="105"/>
        </div>
         <div class="col-md-4">
        </div>
          <div class="col-md-1">
             
        </div>
         <div class="col-md-1">
              <img src="http://www.amezquita.com.co/wp-content/uploads/2015/03/pkf-logo.jpg" style="padding-top:50px" />
        </div>
            <div class="col-md-1">
             
        </div>
        
        
       
    </div>
    <br />
    <div class="row">
      
        <div class="col-md-1">
        </div>
        <div class="col-md-4">          
            <div class="form-group">
                <label>Cliente</label>

              <%--  <select class="form-control" id="ListadoClientes">
                </select>--%>
                <div class="form-inline">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-search" aria-hidden="true"></i></span>
                       <div id="ListadoClientes">

                       </div>
                    </div>
                </div>
                  
            </div>
         </div>   
          <div class="col-md-4">            
          <div class="form-group">
                <label>Servicio</label>
                <select class="form-control" id="serviciosCliente">

                    
                </select>
            </div>
         </div>   
        
         <div class="col-md-2"> 
               <label style="color:white">Servicio</label>  
              <button type="button" id="Consultar" class="btn btn-primary form-control">Consultar</button>      
          </div>
    </div>
    <br/>
  

    <div class="row">
         <div class="col-md-1"></div>         
        
          <div class="col-md-4">
                <input type="text" placeholder="Fecha Archivo" id="datepicker" class="form-control">                         
          </div>
         
         <div class="col-md-4">
                <input type="text" placeholder="Fecha Archivo" id="datepicker2" class="form-control">                         
          </div>
    
         <div class="col-md-2">   
              <button type="button" id="Reporte" class="btn btn-primary form-control">Reporte</button>      
          </div>
       
    </div>
    
    <br />
    <br />

    <div class="row">
          <div class="col-md-12">
            <div id='calendar'></div>
          </div>
     </div> 

    <div class="modal fade" tabindex="-1" id="Modaltree" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Modal title</h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

    <div class="modal fade bs-example-modal-lg" id="modalReporte" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header panel panel-default">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="TitleReporte"></h4>
      </div>
      <div class="modal-body">
       <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        
</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
       
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

    </div>
    <div class="modal fade" id="modalRsult" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div  class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Modal title</h4>
      </div>
      <div class="modal-body">
          <div class="row">
                    <div class="">
                        <div class="col-lg-12 container">
                            <div class="panel panel-default">
                                <!-- /.panel-heading -->
                                <div class="panel-body">
                                    <div class="dataTable_wrapper">
                                        <div class="table-responsive">
                                            <table class="table table table-striped table table-hover table table-bordered" id="ReporteDiario" style="font-size:x-small">
                                               
                                                <tr style="display:none">
                                                    <th rowspan="3"> <img src="http://www.amezquita.com.co/wp-content/uploads/2015/03/Logo-en-Policrom--a-e1443198604156.png"  width="200" height="78"/></th>
                                                    <th>Proyecto</th>
                                                    <th>Servicio</th>
                                                    <th>Fecha Inicio</th>
                                                     <th>Fecha Final</th>
                                                </tr>
                                                 <tr style="display:none">
                                                  
                                                    <td id="ReporteProyecto"></td>
                                                     <td id="ReporteServicio"></td>
                                                       <td id="ReporteFechaInicio"></td>
                                                      <td id="ReporteFechaFinal"></td>
                                                </tr>
                                                <tr style="display:none">
                                                    <td></td>
                                                </tr>
                                                <thead id="Cabezera">
                                                   
                                                   

                                                </thead>

                                                <tbody id="rSultQuery">
                                                </tbody>

                                              

                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
     
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" id="generarReporte" class="btn btn-primary">Generar Reporte</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</body>
<script></script>

</html>