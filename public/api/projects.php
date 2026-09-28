<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$dataFile = __DIR__ . '/projects_db.json';

// Si no existe la base de datos, crearla con datos iniciales
if (!file_exists($dataFile)) {
    $defaultData = [
        "EQUI-2026" => [
            "clientName" => "EQUI Salud SAC",
            "projectName" => "Plataforma Médica & Apps",
            "activeVersion" => "v2.1.0-rc",
            "progress" => 0.92,
            "nextDelivery" => "Próxima entrega prevista en 2 días.",
            "demoUrl" => "https://mktia.pe/#proyectos",
            "status" => "En Pruebas Finales"
        ],
        "LIVO-PROP" => [
            "clientName" => "LIVO Inmobiliaria",
            "projectName" => "SaaS de Administración de Condominios",
            "activeVersion" => "v1.4.2-staging",
            "progress" => 0.74,
            "nextDelivery" => "Próxima entrega prevista en 4 días.",
            "demoUrl" => "https://mktia.pe/#proyectos",
            "status" => "En Desarrollo Activo"
        ]
    ];
    file_put_contents($dataFile, json_encode($defaultData, JSON_PRETTY_PRINT));
}

// 1. OBTENER DATOS (La App Móvil consulta por su código)
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $code = isset($_GET['code']) ? strtoupper(trim($_GET['code'])) : '';
    $data = json_decode(file_get_contents($dataFile), true);

    if (empty($code)) {
        echo json_encode(["status" => "success", "projects" => $data]);
        exit;
    }

    if (isset($data[$code])) {
        echo json_encode(["status" => "success", "project" => $data[$code]]);
    } else {
        http_response_code(404);
        echo json_encode(["status" => "error", "message" => "Código de proyecto no encontrado"]);
    }
    exit;
}

// 2. GUARDAR / ACTUALIZAR DATOS (Tu Panel Admin guarda los cambios)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (!$input || empty($input['code'])) {
        http_response_code(400);
        echo json_encode(["status" => "error", "message" => "Datos incompletos"]);
        exit;
    }

    $code = strtoupper(trim($input['code']));
    $data = json_decode(file_get_contents($dataFile), true);

    $data[$code] = [
        "clientName" => $input['clientName'],
        "projectName" => $input['projectName'],
        "activeVersion" => $input['version'] ?? "v1.0.0",
        "progress" => (float)($input['progress'] / 100),
        "nextDelivery" => $input['nextDelivery'] ?? "Entrega de sprint programada.",
        "demoUrl" => $input['demoUrl'] ?? "https://mktia.pe",
        "status" => $input['status'] ?? "Activo"
    ];

    file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT));
    echo json_encode(["status" => "success", "message" => "Proyecto guardado correctamente"]);
    exit;
}