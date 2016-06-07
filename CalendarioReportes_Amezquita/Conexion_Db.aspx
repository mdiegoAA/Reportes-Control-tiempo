<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Conexion_Db.aspx.cs" Inherits="CalendarioReportes_Amezquita.Conexion_Db" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="MigrationId,ContextKey" DataSourceID="ControlTiempo">
            <Columns>
                <asp:BoundField DataField="MigrationId" HeaderText="MigrationId" ReadOnly="True" SortExpression="MigrationId" />
                <asp:BoundField DataField="ContextKey" HeaderText="ContextKey" ReadOnly="True" SortExpression="ContextKey" />
                <asp:BoundField DataField="ProductVersion" HeaderText="ProductVersion" SortExpression="ProductVersion" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="ControlTiempo" runat="server" ConnectionString="<%$ ConnectionStrings:CT_pruebasConnectionString %>" SelectCommand="SELECT * FROM [__MigrationHistory]"></asp:SqlDataSource>
    </form>
</body>
</html>
