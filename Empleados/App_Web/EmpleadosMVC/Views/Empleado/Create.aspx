<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<EmpleadosMVC.Models.Empleado>" %>
<%@ Import Namespace="EmpleadosMVC.Helpers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.DisplayNameFor() %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% using (Html.BeginForm()) {%>
		<%= Html.BeginSection("./../Content/images/hpantalla/customers.png", Html.DisplayNameCreateFor().ToHtmlString().ToUpper())%>
		<%= Html.BeginSectionBody()%>
		<%= Html.ValidationSummaryWidget()%>
            
		<%= Html.BeginSectionItemDataRow() %>
        <%= Html.LabelDisplayItemFor(model => model.ID)%>
        <%= Html.LabelEditorValidationItemFor(model => model.DNI) %>
        <%= Html.LabelEditorValidationItemFor(model => model.Nombre) %>
		<%= Html.LabelEditorValidationItemFor(model => model.Telefono) %>
		<%= Html.LabelEditorValidationItemFor(model => model.Correo) %>
        <%= Html.LabelEditorValidationItemFor(model => model.Direccion) %>
        <%= Html.LabelEditorValidationItemFor(model => model.Sueldo) %>
        <%= Html.LabelEditorValidationItemFor(model => model.SueldoAnual) %>
        <%= Html.LabelSpinnerValidationItemFor(model => model.Estatus)%>
        <%= Html.DropDownListItemFor(model => model.TipoContracto.ID, Model.TipoContracto.ToEntitySelectList())%>
        <%= Html.EndSectionItemDataRow()%>

        <%= Html.EndSectionBody()%>
        <%= Html.BeginBarButtons()%>
        <%= Html.BarButtonsCreate()%>
        <%= Html.EndBarButtons()%>
        <%= Html.EndSection()%>
    <% } %>

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

