<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="EmpleadosMVC.Helpers.Menu" %>
<div id="mainMenu" runat="server" active="3">
    
    <%= Html.BeginMenuItem("Maestros")%>
        <%= Html.MenuItemLink("../../Content/images/hbotons/customers.png", " Empleados", "List", "Empleado")%>
        <%= Html.MenuItemLink("../../Content/images/hbotons/customer.png", " TipoContracto", "List", "TipoContracto")%>
    <%= Html.EndMenuItem()%>
    
    <%= Html.BeginMenuItem("Ayuda")%>
        <%= Html.MenuItemLink("../../Content/images/hbotons/about.png", "About", "About", "Home")%>
    <%= Html.EndMenuItem()%>
    
    <asp:TextBox ID="active" runat="server" style="display:none" ></asp:TextBox>
</div>

<% 
   if (this.Session["imnu"] == null)
   {
       this.Session["imnu"] = 0;
   }
   if (Request.QueryString["imnu"] != null)
   {
       try
       {
           this.Session["imnu"] = int.Parse(Request.QueryString["imnu"]);
       }
       catch { this.Session["imnu"] = 0; }
   }
   int MenuOption = (int)this.Session["imnu"];        
%>

<script type="text/javascript">
//<![CDATA[
    $(function() {
        var mainMenu = $("#<%=this.mainMenu.ClientID %>")

        $(mainMenu).accordion
		({
		    collapsible: true,
		    heightStyle: "fill",
		    active: parseInt("<%=MenuOption %>")
		    //activate: function(event, ui) { 
		    // event activate panel menu
		    //}
		});

        mvcLocal.utility.setActionMenu(mainMenu);
    });
//]]>
</script>
