<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<EmpleadosMVC.Models.TipoContracto>" %>
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
        <%= Html.LabelEditorValidationItemFor(model => model.Codigo)%>
		<%= Html.LabelEditorValidationItemFor(model => model.Descripcion) %>
        <%= Html.LabelEditorValidationItemFor(model => model.MultiploAnual) %>
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

