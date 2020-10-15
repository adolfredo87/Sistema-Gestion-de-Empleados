<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<EmpleadosMVC.Models.Empleado>" %>
<%@ Import Namespace="EmpleadosMVC.Helpers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.DisplayNameFor() %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
   <% using (Html.BeginForm()){%>
        <%= Html.BeginSection("./../Content/images/hpantalla/customers.png", Html.DisplayNameFor().ToHtmlString().ToUpper())%>
        <%= Html.BeginSectionBody(true)%>        
        <%= Html.GridJQuery("Empleado")%>  
        <%= Html.EndSectionBody()%> 
        <%= Html.BeginBarButtons()%>
        <%= Html.ActionLinkCreate()%>
        <%= Html.ActionLinkPrintGrid("Empleado")%>
        <%= Html.ActionLinkHome()%>      
        <%= Html.EndBarButtons()%>
        <%= Html.EndSection()%>
    <%}%>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
	<script type='text/javascript'>
		//<![CDATA[
	    var mvcSectionBox = $("#MvcSectionBox");
	    // 
	    // Procedimientos para Configuracion del grid
	    $(function () {
	        var jqTableGrid = mvcLocal.jqGrid.init("Empleado");
	        //
	        // Specify the column names
	        jqTableGrid.mvcUI.config.options.colNames = ["ID", "DNI", "Nombre", "Telefono", "Correo", "Sueldo", "SueldoAnual", "TipoContracto", "Estatus", "Acciones"];
	        //
	        // Configure the columns
	        jqTableGrid.mvcUI.config.options.colModel =
				[
					{ name: "ID", index: "ID", width: 20, align: "left" },
                    { name: "DNI", index: "DNI", width: 40, align: "left" },
					{ name: "Nombre", index: "Nombre", width: 60, align: "left" },
					{ name: "Telefono", index: "Telefono", width: 55, align: "left" },
					{ name: "Correo", index: "Correo", width: 70, align: "left" },
                    { name: "Sueldo", index: "Sueldo", width: 30, align: "left" },
                    { name: "SueldoAnual", index: "SueldoAnual", width: 45, align: "left" },
                    { name: "TipoContracto", index: "TipoContracto", width: 65, align: "left" },
                    { name: "Estatus", index: "Estatus", width: 30, align: "left" }, 
					mvcLocal.jqGrid.columnActions
				];
	        //
	        // Default sorting
	        jqTableGrid.mvcUI.config.options.sortname = "ID";
	        //
	        // load and set up the jquery grid
	        mvcLocal.jqGrid.loadGrid(jqTableGrid);

	    });
        //]]>
    </script>
</asp:Content>

