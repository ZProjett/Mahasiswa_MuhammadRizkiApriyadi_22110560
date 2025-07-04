<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tambah Mahasiswa</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* Gaya CSS tetap sama */
        .form-container {
            width: 400px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-container h2 {
            text-align: center;
            color: #0d47a1;
            margin-bottom: 20px;
        }
        .form-container label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }
        .form-container input[type="text"],
        .form-container input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        .form-container input[type="submit"] {
            margin-top: 20px;
            width: 100%;
            padding: 12px;
            background-color: #1976d2;
            border: none;
            color: white;
            font-weight: 500;
            border-radius: 6px;
            cursor: pointer;
        }
        .form-container input[type="submit"]:hover {
            background-color: #1565c0;
            transform: scale(1.02);
        }
        .btn-kembali {
            display: block;
            margin: 20px auto;
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
        .error-msg {
            color: red;
            font-size: 14px;
            margin-top: 10px;
            text-align: center;
        }
    </style>

    <script>
        function validateForm() {
            const nim = document.getElementById("nim").value.trim();
            const nama = document.getElementById("nama").value.trim();
            const nilai = document.getElementById("nilai").value.trim();

            if (!/^\d{8}$/.test(nim)) {
                alert("NIM harus terdiri dari 8 angka.");
                return false;
            }

            if (nama === "") {
                alert("Nama tidak boleh kosong.");
                return false;
            }

            const nilaiAngka = parseInt(nilai);
            if (isNaN(nilaiAngka) || nilaiAngka < 0 || nilaiAngka > 100) {
                alert("Nilai harus berupa angka antara 0 - 100.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>

<header>
    <div class="logo">🎓 Portal Mahasiswa</div>
    <div class="info-header">🚀 Praktek Java Lanjutan </div>
</header>

<div class="form-container">
    <h2>Tambah Data Mahasiswa</h2>

    <% String error = request.getParameter("error"); %>
    <% if ("nama".equals(error)) { %>
        <div class="error-msg">Nama sudah terdaftar, gunakan nama lain.</div>
    <% } else if ("nim".equals(error)) { %>
        <div class="error-msg">NIM sudah terdaftar, gunakan NIM lain.</div>
    <% } else if ("nilai".equals(error)) { %>
        <div class="error-msg">Nilai tidak valid.</div>
    <% } else if ("gagal".equals(error)) { %>
        <div class="error-msg">Terjadi kesalahan saat menyimpan data.</div>
    <% } %>

    <form action="proses_tambah.jsp" method="post" onsubmit="return validateForm()">
        <label for="nim">NIM:</label>
        <input type="text" name="nim" id="nim" required maxlength="8">

        <label for="nama">Nama:</label>
        <input type="text" name="nama" id="nama" required>

        <label for="nilai">Nilai:</label>
        <input type="number" name="nilai" id="nilai" required min="0" max="100">

        <input type="submit" value="Simpan">
    </form>
</div>

<a href="index.jsp" class="btn-kembali">⬅ Kembali ke Menu Utama</a>

<footer>&copy; 2025 Portal Mahasiswa</footer>

</body>
</html>
