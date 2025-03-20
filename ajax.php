<?php
use WHMCS\Database\Capsule;

require_once __DIR__ . '/../../../init.php';
require_once __DIR__ . '/../../../includes/functions.php';

function apiRequest($url, $method, $data = null) {
    $api_key = "NEPROTECT_API_KEY";
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        "Authorization: Bearer " . $api_key
    ]);
    if ($method == "POST") {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    } elseif ($method == "DELETE") {
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    }
    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        error_log("cURL error in apiRequest: " . curl_error($ch));
    }
    curl_close($ch);
    return json_decode($response, true);
}

function getInfo($ip){
    $url = "https://api.neoprotect.net/v2/ips/$ip";
    return apiRequest($url, "GET");
}

function getAttacks($ip){
    $url = "https://api.neoprotect.net/v2/ips/$ip/attacks";
    return apiRequest($url, "GET");
}





function verifyIpOwnership($userId, $ip) {
    $command = 'GetClientsProducts';
    $postData = [
        'clientid' => $userId,
        'stats'    => true,
    ];
    $results = localAPI($command, $postData);
    if ($results['result'] === 'success') {
        foreach ($results['products']['product'] as $product) {
            if (strtolower($product['status']) !== 'active') {
                continue;
            }
            $dedicatedIp = trim($product['dedicatedip']);
            $assignedIps = array_map('trim', explode(',', $product['assignedips']));
            if ($ip === $dedicatedIp || in_array($ip, $assignedIps)) {
                return true;
            }
        }
    }
    return false;
}

header('Content-Type: application/json; charset=utf-8');

$clientId = isset($_SESSION['uid']) ? (int) $_SESSION['uid'] : 0;
if (!$clientId) {
    echo json_encode(['error' => 'Unauthorized: no active WHMCS session']);
    exit;
}

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$ip     = isset($_REQUEST['ip'])     ? $_REQUEST['ip']     : null;

if (!$action) {
    echo json_encode(['error' => 'No action specified.']);
    exit;
}
if (!$ip) {
    echo json_encode(['error' => 'No IP specified.']);
    exit;
}

if (!verifyIpOwnership($clientId, $ip)) {
    echo json_encode(['error' => 'Not authorized to manage this IP.']);
    exit;
}

switch ($action) {
    case 'getPresets':
        $url = "https://api.neoprotect.net/v2/profiles/presets";
        $response = apiRequest($url, "GET");
        echo json_encode($response);
        break;

    case 'getProfiles':
        $ip = isset($_REQUEST['ip']) ? $_REQUEST['ip'] : null;
        if (!$ip) {
            echo json_encode([]);
            exit;
        }
        $url = "https://api.neoprotect.net/v2/ips/$ip/profiles";
        $response = apiRequest($url, "GET");
        echo json_encode($response);
        break;

    case 'createProfile':
        $ip = isset($_REQUEST['ip']) ? $_REQUEST['ip'] : null;
        $jsonData = isset($_REQUEST['data']) ? $_REQUEST['data'] : '';
        if (!$ip || empty($jsonData)) {
            echo json_encode(['error' => 'Missing parameters.']);
            exit;
        }

        $jsonData = html_entity_decode($jsonData);
        $jsonData = urldecode($jsonData);

        $dataArray = json_decode($jsonData, true);
        if (!$dataArray) {
            echo json_encode(['error' => 'Invalid JSON payload.']);
            exit;
        }

        if (empty($dataArray['notes'])) {
            unset($dataArray['notes']);
        }
  
        $dataArray['listId'] = "";

        $url = "https://api.neoprotect.net/v2/ips/$ip/profiles";
        $response = apiRequest($url, "POST", json_encode($dataArray));
        echo json_encode($response);
        break;

    case 'updateProfile':
        $profileId = isset($_REQUEST['profileId']) ? $_REQUEST['profileId'] : null;
        $jsonData = isset($_REQUEST['data']) ? $_REQUEST['data'] : '';
        if (!$profileId || empty($jsonData)) {
            echo json_encode(['error' => 'Missing parameters.']);
            exit;
        }
        $url = "https://api.neoprotect.net/v2/profiles/$profileId";
        $response = apiRequest($url, "PUT", $jsonData);
        echo json_encode($response);
        break;

    case 'deleteProfile':
        $profileId = isset($_REQUEST['profileId']) ? $_REQUEST['profileId'] : null;
        if (!$profileId) {
            echo json_encode(['error' => 'Missing profileId.']);
            exit;
        }
        $url = "https://api.neoprotect.net/v2/profiles/$profileId";
        $response = apiRequest($url, "DELETE");
        echo json_encode($response);
        break;

    case 'getInfo':
        $res = getInfo($ip);
        echo json_encode($res);
        break;

    case 'getAttacks':
        $res = getAttacks($ip);
        echo json_encode($res);
        break;

    case 'saveDefaultAction':
        $defaultAction = isset($_REQUEST['defaultAction']) ? $_REQUEST['defaultAction'] : 'FILTER';
        $data = [
            "defaultAction" => $defaultAction
        ];
        $url = "https://api.neoprotect.net/v2/ips/$ip";
        $response = apiRequest($url, "POST", json_encode($data));
        echo 'ok';
        break;

    case 'saveSettings':
        $attackDuration = isset($_REQUEST['attackDuration']) ? $_REQUEST['attackDuration'] : 30;
        $allowEgress = isset($_REQUEST['allowEgress']) ? $_REQUEST['allowEgress'] : false;
        $ackCheck = isset($_REQUEST['ackCheck']) ? $_REQUEST['ackCheck'] : false;
        $symmetrical = isset($_REQUEST['symmetrical']) ? $_REQUEST['symmetrical'] : false;
        $symmetricalBasic = isset($_REQUEST['symmetricalBasic']) ? $_REQUEST['symmetricalBasic'] : false;
        $synThreshold = isset($_REQUEST['synThreshold']) ? $_REQUEST['synThreshold'] : 128;
        $ackThreshold = isset($_REQUEST['ackThreshold']) ? $_REQUEST['ackThreshold'] : 512;
        $firstFragmentThreshold = isset($_REQUEST['firstFragmentThreshold']) ? $_REQUEST['firstFragmentThreshold'] : 128;
        $fragmentThreshold = isset($_REQUEST['fragmentThreshold']) ? $_REQUEST['fragmentThreshold'] : 512;
        $ampThreshold = isset($_REQUEST['ampThreshold']) ? $_REQUEST['ampThreshold'] : 1024;
        $udpThreshold = isset($_REQUEST['udpThreshold']) ? $_REQUEST['udpThreshold'] : 2048;
        $symmetricalThreshold = isset($_REQUEST['symmetricalThreshold']) ? $_REQUEST['symmetricalThreshold'] : 0;
        $tcpConnLimit = isset($_REQUEST['tcpConnLimit']) ? $_REQUEST['tcpConnLimit'] : 15000;
        $tcpConnBytesLimit = isset($_REQUEST['tcpConnBytesLimit']) ? $_REQUEST['tcpConnBytesLimit'] : 60000000;
        $udpConnLimit = isset($_REQUEST['udpConnLimit']) ? $_REQUEST['udpConnLimit'] : 15000;
        $udpConnBytesLimit = isset($_REQUEST['udpConnBytesLimit']) ? $_REQUEST['udpConnBytesLimit'] : 30000000;
        $udpNewConnLimit = isset($_REQUEST['udpNewConnLimit']) ? $_REQUEST['udpNewConnLimit'] : 500;
        $synLimit = isset($_REQUEST['synLimit']) ? $_REQUEST['synLimit'] : 5000;
        $icmpLimit = isset($_REQUEST['icmpLimit']) ? $_REQUEST['icmpLimit'] : 512;
        $udpLengthBytesLimit = isset($_REQUEST['udpLengthBytesLimit']) ? $_REQUEST['udpLengthBytesLimit'] : 12500000;

        $data = [
            "attackDuration" => $attackDuration,
            "allowEgress" => $allowEgress,
            "ackCheck" => $ackCheck,
            "symmetrical" => $symmetrical,
            "symmetricalBasic" => $symmetricalBasic,
            "synThreshold" => $synThreshold,
            "ackThreshold" => $ackThreshold,
            "firstFragmentThreshold" => $firstFragmentThreshold,
            "fragmentThreshold" => $fragmentThreshold,
            "ampThreshold" => $ampThreshold,
            "udpThreshold" => $udpThreshold,
            "symmetricalThreshold" => $symmetricalThreshold,
            "tcpConnLimit" => $tcpConnLimit,
            "tcpConnBytesLimit" => $tcpConnBytesLimit,
            "udpConnLimit" => $udpConnLimit,
            "udpConnBytesLimit" => $udpConnBytesLimit,
            "udpNewConnLimit" => $udpNewConnLimit,
            "synLimit" => $synLimit,
            "icmpLimit" => $icmpLimit,
            "udpLengthBytesLimit" => $udpLengthBytesLimit,
            "autoMitigation" => false,
            "localMinPort" => 32768,
            "localMaxPort" => 61000,
            "cache" => false,
            "syncStates" => true,
            "dropSameSubnet" => false,
            "udpStrict" => false,
            "sampleRate" => "1000",
            "maxProfiles" => "100",
            "maxPorts" => "1000"
        ];

        $url = "https://api.neoprotect.net/v2/ips/$ip";
        $response = apiRequest($url, "POST", json_encode($data));

        echo 'ok';
        break;

    case 'saveAsnFiltering':
        $ip = isset($_REQUEST['ip']) ? $_REQUEST['ip'] : null;
        $jsonData = isset($_REQUEST['data']) ? $_REQUEST['data'] : '';
        if (!$ip || empty($jsonData)) {
            echo json_encode(['error' => 'Missing parameters.']);
            exit;
        }
        $jsonData = html_entity_decode($jsonData);
        $dataArray = json_decode($jsonData, true);
        if (!$dataArray) {
            echo json_encode(['error' => 'Invalid JSON.']);
            exit;
        }

        $dataArray['asnBlockMode'] = (int)$dataArray['asnBlockMode'];
        $dataArray['asnBlockList'] = array_map('intval', $dataArray['asnBlockList']);

        $dataArray['countryBlockMode'] = (int)$dataArray['countryBlockMode'];
        $dataArray['countryBlockList'] = array_map('strval', $dataArray['countryBlockList']);

        $jsonData = json_encode($dataArray);
        $url = "https://api.neoprotect.net/v2/ips/$ip";
        $response = apiRequest($url, "POST", $jsonData);
        echo json_encode($response);
        break;

    case 'getCountries':
        $url = "https://api.neoprotect.net/v2/public/countries";
        $response = apiRequest($url, "GET");
        echo json_encode($response);
        break;

    default:
        echo json_encode(['error' => 'Invalid action.']);
        break;
}
exit;
