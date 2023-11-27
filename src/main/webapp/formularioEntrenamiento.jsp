<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<h2>Introduzca los datos del nuevo entrenamiento:</h2>
<form method="get" action="grabaEntrenamiento.jsp">
    Tipo <select name="tipo">
            <option value="fisico">Fisico</option>
            <option value="tecnico">Tecnico</option>
        </select></br>
    Ubicacion <input type="text" name="ubicacion"/></br>
    Fecha <input type="text" name="fecha"/></br>
    <input type="submit" value="Aceptar">
</form>

<%
    String error = (String)session.getAttribute("error");
    if (error != null){
        %>
        <span style="color: orangered"><%= error %></span>
        <%
        session.removeAttribute("error");
    }
%>
</body>
</html>