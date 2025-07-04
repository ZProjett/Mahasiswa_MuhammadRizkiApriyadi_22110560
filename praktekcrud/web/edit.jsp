<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Data Mahasiswa</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f8fb;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #0d47a1;
            margin-top: 30px;
        }

        form {
            width: 50%;
            margin: 30px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 16px;
        }

        input[type="submit"] {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        .btn-kembali {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #1976d2;
            font-weight: 500;
        }

        footer {
            text-align: center;
            padding: 20px;
            background-color: #0d47a1;
            color: white;
            position: fixed;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>
<body>

<header>
    <div class="logo">🎓 Portal Mahasiswa</div>
    <div class="info-header">🚀 Praktek Java Lanjutan </div>
</header>

<%
    String id = request.getParameter("id");
    String nim = "", nama = "";
    int nilai = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crud", "root", "");
        String sql = "SELECT * FROM mahasiswa WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(id));
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            nim = rs.getString("nim");
            nama = rs.getString("nama");
            nilai = rs.getInt("nilai");
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Gagal mengambil data!</p>");
    }
%>

<h2>Edit Data Mahasiswa</h2>
<form action="proses_edit.jsp" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="id" value="<%= id %>">

    <label for="nim">NIM:</label>
   <input type="text" name="nim" id="nim" value="<%= nim %>" required pattern="\d{8}" maxlength="8" title="NIM harus terdiri dari 8 digit angka">

    <label for="nama">Nama:</label>
    <input type="text" name="nama" id="nama" value="<%= nama %>">

    <label for="nilai">Nilai:</label>
    <input type="number" name="nilai" id="nilai" value="<%= nilai %>">

    <input type="submit" value="Update Data">
</form>

<a href="lihat.jsp" class="btn-kembali">⬅ Kembali ke Data Mahasiswa</a>

<footer>&copy; 2025 Portal Mahasiswa</footer>

<script>
function validateForm() {
    const nim = document.getElementById("nim").value.trim();
    const nama = document.getElementById("nama").value.trim();
    const nilai = document.getElementById("nilai").value.trim();

    if (nim === "" || nama === "" || nilai === "") {
        alert("Semua field harus diisi!");
        return false;
    }

    if (!/^\d{8}$/.test(nim)) {
        alert("NIM harus terdiri dari 8 digit angka!");
        return false;
    }

    if (isNaN(nilai) || parseInt(nilai) < 0) {
        alert("Nilai harus berupa angka positif!");
        return false;
    }

    return true;
}
</script>

</body>
</html>
