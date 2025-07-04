<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data Mahasiswa</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f0f4f8;
        }

        .search-box {
            text-align: center;
            margin-top: 30px;
        }

        .search-box form {
            display: inline-block;
            position: relative;
        }

        .search-box input[type="text"] {
            padding: 8px 35px 8px 15px;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        .search-box button {
            padding: 9px 18px;
            background-color: #1976d2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-left: 10px;
        }

        .search-box button:hover {
            background-color: #1565c0;
        }

        .clear-btn {
            position: absolute;
            right: 110px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #888;
            cursor: pointer;
            padding: 0 5px;
        }

        .clear-btn:hover {
            color: crimson;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: linear-gradient(to right, #0d47a1, #1976d2);
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f4f8fb;
        }

        h2 {
            text-align: center;
            color: #0d47a1;
            margin-top: 30px;
        }

        .btn-kembali {
            display: block;
            margin: 20px auto 40px auto;
            background-color: #1976d2;
            color: white;
            padding: 10px 25px;
            border: none;
            font-weight: 500;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }

        .btn-kembali:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        .aksi a {
            margin: 0 5px;
            text-decoration: none;
            color: white;
            background-color: #1976d2;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
        }

        .aksi a.hapus {
            background-color: crimson;
        }

        .aksi a:hover {
            opacity: 0.9;
        }

        header {
            background-color: #0d47a1;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .info-header {
            font-size: 16px;
        }
    </style>
</head>
<body>

<header>
    <div class="logo">🎓 Portal Mahasiswa</div>
    <div class="info-header">🚀 Praktek Java Lanjutan </div>
</header>

<h2>Data Mahasiswa</h2>

<div class="search-box">
    <form method="get" action="lihat.jsp" id="searchForm">
        <input 
            type="text" 
            name="keyword" 
            id="keywordInput"
            placeholder="Cari berdasarkan NIM, Nama, atau Nilai" 
            value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
        <% if (request.getParameter("keyword") != null && !request.getParameter("keyword").trim().equals("")) { %>
            <span class="clear-btn" onclick="clearSearch()">×</span>
        <% } %>
        <button type="submit">🔍 Cari</button>
    </form>
</div>

<%
    String keyword = request.getParameter("keyword");
    String url = "jdbc:mysql://localhost:3306/crud";
    String user = "root";
    String pass = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String sql = "SELECT * FROM mahasiswa";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE nim LIKE ? OR nama LIKE ? OR nilai LIKE ?";
        }

        stmt = conn.prepareStatement(sql);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String likeKeyword = "%" + keyword + "%";
            stmt.setString(1, likeKeyword);
            stmt.setString(2, likeKeyword);
            stmt.setString(3, likeKeyword);
        }

        rs = stmt.executeQuery();
        int no = 1;
        boolean adaData = false;
%>

<table>
    <tr>
        <th>No</th>
        <th>NIM</th>
        <th>Nama</th>
        <th>Nilai</th>
        <th>Aksi</th>
    </tr>
    <% while (rs.next()) {
           adaData = true;
    %>
    <tr>
        <td><%= no++ %></td>
        <td><%= rs.getString("nim") %></td>
        <td><%= rs.getString("nama") %></td>
        <td><%= rs.getInt("nilai") %></td>
        <td class="aksi">
            <a href="edit.jsp?id=<%= rs.getInt("id") %>">Edit</a>
            <a href="#" class="hapus" onclick="showDeleteModal('<%= rs.getInt("id") %>')">Hapus</a>
        </td>
    </tr>
    <% } %>
    <% if (!adaData) { %>
    <tr>
        <td colspan="5" style="text-align: center; color: red;">Data tidak tersedia</td>
    </tr>
    <% } %>
</table>

<%
        rs.close(); stmt.close(); conn.close();
    } catch (Exception e) {
%>
    <p style="color: red; text-align: center;">Terjadi kesalahan saat mengambil data mahasiswa.</p>
<%
    }
%>

<a href="index.jsp" class="btn-kembali">⬅ Kembali ke Menu Utama</a>

<footer style="text-align: center; margin-top: 30px;">© 2025 Portal Mahasiswa</footer>

<script>
function clearSearch() {
    document.getElementById("keywordInput").value = "";
    document.getElementById("searchForm").submit();
}

function showDeleteModal(id) {
    Swal.fire({
        title: 'Konfirmasi Penghapusan',
        text: 'Yakin ingin menghapus data ini?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#28a745', // Hijau untuk "Ya"
        cancelButtonColor: '#dc3545', // Merah untuk "Batal"
        confirmButtonText: '<i class="fas fa-check"></i> Ya',
        cancelButtonText: '<i class="fas fa-times"></i> Batal',
        reverseButtons: true,
        customClass: {
            popup: 'animated fadeInDown',
            confirmButton: 'btn btn-success',
            cancelButton: 'btn btn-danger'
        },
        showClass: {
            popup: 'animate__animated animate__bounceIn'
        },
        hideClass: {
            popup: 'animate__animated animate__bounceOut'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'hapus.jsp?id=' + id;
        }
    });
}
</script>

</body>
</html>