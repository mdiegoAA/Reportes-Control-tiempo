<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Arboles.aspx.cs" Inherits="CalendarioReportes_Amezquita.Arboles" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>jsTree test</title>
  <!-- 2 load the theme CSS file -->
      <link rel="stylesheet" href="//www.fuelcdn.com/fuelux/3.13.0/css/fuelux.min.css">

    <!-- Latest compiled and minified JavaScript -->
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
    <script src="//www.fuelcdn.com/fuelux/3.13.0/js/fuelux.min.js"></script>
  <link rel="stylesheet" href="dist/themes/default/style.min.css" />
<script>
    $(document).ready(function () {
     
        $('#myTree').tree({
            dataSource: function (options, callback) {
                setTimeout(function () {
                    callback({
                        data: [
                            {
                                name: 'Folder 1',
                                type: 'folder',
                                additionalParameters: { id: 'F1' },
                                children: [
                                    {
                                        name: 'Sub Folder 1',
                                        type: 'folder',
                                        additionalParameters: { id: 'FF1' }
                                    }
                                ]
                            },
                            {
                                name: 'Folder 2',
                                type: 'folder',
                                additionalParameters: { id: 'F2' }
                            },
                            {
                                name: 'Item 1',
                                type: 'item',
                                additionalParameters: { id: 'I1' }
                            },
                            {
                                name: 'Item 2',
                                type: 'item',
                                additionalParameters: { id: 'I2' }
                            }
                        ],
                        delay: 400
                    });
                }, 400);
            },
            multiSelect: true,
            cacheItems: true,
            folderSelect: false
        });
    });
</script>
</head>
<body>
  <!-- 3 setup a container element -->
  <div id="myTree">
    <!-- in this example the tree is populated from inline HTML -->
  
  </div>

 
</body>
</html>
 