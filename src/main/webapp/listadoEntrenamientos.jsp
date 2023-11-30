<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="estilos.css" />
</head>
<body>
<h1>Listado de entrenamientos</h1>
<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto","root", "user");
    Statement s = conexion.createStatement();

    ResultSet listado = s.executeQuery ("SELECT * FROM entrenamiento");
%>
<table>
    <tr><th>Código</th><th>Tipo</th><th>Ubicacion</th><th>Fecha</th></tr>
    <%
        Integer entrenamientoIDADestacar = (Integer)session.getAttribute("entrenamientoIDADestacar");

        String claseDestacar = "";

        while (listado.next()) {

            if (entrenamientoIDADestacar != null && entrenamientoIDADestacar == listado.getInt("entrenamientoID")){
                claseDestacar = "destacar";
            } else{
                claseDestacar = "";
            }


    %>
    <tr <%out.println("class=\""+claseDestacar+"\"");%>>

        <td <%out.println("class=\""+claseDestacar+"\"");%>>
                <%out.println("<a href=\"detalleEntrenamiento.jsp?entrenamientoID="+listado.getInt("entrenamientoID")+"\">"+listado.getInt("entrenamientoID") + "</a></td>");%>
        <td>
            <%=listado.getString("tipo")%>
        </td>
        <td>
            <%=listado.getString("ubicacion")%>
        </td>
        <td>
            <%=listado.getDate("fecha")%>
        </td>

        <td>
            <form method="get" action="borraEntrenamiento.jsp">
                <input type="hidden" name="codigo" value="<%=listado.getString("entrenamientoID") %>"/>
                <input type="submit" value="borrar">
            </form>
        </td></tr>
    <%
        } // while
        conexion.close();
    %>
</table>
</body>
</html>