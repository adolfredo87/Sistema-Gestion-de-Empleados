<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<EmpleadosMVC.Models.Empleado>" %>
<%@ Import Namespace="EmpleadosMVC.Helpers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.DisplayNameFor() %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<% using (Html.BeginForm()){%>       
		<%=  Html.BeginSection("../../Content/images/hpantalla/customers.png", Html.DisplayNameDetailsFor().ToHtmlString().ToUpper())%>
		<%=  Html.BeginSectionBody()%>
		
		<%=  Html.BeginSectionItemDataRow() %>
		<%=  Html.LabelDisplayItemFor(model => model.ID)%>
        <%=  Html.LabelDisplayItemFor(model => model.DNI)%>
		<%=  Html.LabelDisplayItemFor(model => model.Nombre)%>
		<%=  Html.LabelDisplayItemFor(model => model.Telefono)%>
        <%=  Html.LabelDisplayItemFor(model => model.Correo)%>
        <%=  Html.LabelDisplayItemFor(model => model.Direccion)%>    
        <%=  Html.LabelDisplayItemFor(model => model.Sueldo)%>
        <%=  Html.LabelDisplayItemFor(model => model.SueldoAnual)%>    
        <%=  Html.LabelDisplayItemFor(model => model.Estatus)%>
        <%=  Html.LabelDisplayItemFor(model => model.TipoContracto.Descripcion)%>
        <%=  Html.EndSectionItemDataRow()%>

		<%=  Html.EndSectionBody()%>
		<%=  Html.BeginBarButtons()%>
		<%=  Html.ActionLinkBack() %>
		<%=  Html.EndBarButtons()%>
		<%=  Html.EndSection()%>
	<%}%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
	<script type='text/javascript'>
		//<![CDATA[
	    var mvcSectionBox = $("#MvcSectionBox");
	    $(function () {

	    });
		//]]>
	</script>
	
</asp:Content>

