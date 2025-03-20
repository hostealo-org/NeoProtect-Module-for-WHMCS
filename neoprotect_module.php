<?php
if (!defined("WHMCS")) {
    die("Direct access not allowed.");
}

function neoprotect_module_config() {
    return [
        'name'        => 'NeoProtect Module',
        'description' => 'Module to manage NeoProtect in the Client Area.',
        'version'     => '1.0',
        'author'      => 'Hostealo.es',
        'language'    => 'spanish',
    ];
}

function neoprotect_module_activate() {
    return [
        'status'      => 'success',
        'description' => 'NeoProtect Module activated successfully.',
    ];
}

function neoprotect_module_deactivate() {
    return [
        'status'      => 'success',
        'description' => 'NeoProtect Module deactivated successfully.',
    ];
}

function neoprotect_module_clientarea($vars) {

    $clientId = isset($_SESSION['uid']) ? (int) $_SESSION['uid'] : 0;
    $services = [];

    if ($clientId) {
        $command  = 'GetClientsProducts';
        $postData = [
            'clientid' => $clientId,
            'stats'    => true,
        ];
        $results = localAPI($command, $postData);
        if ($results['result'] === 'success') {
            $ipSet = [];

            foreach ($results['products']['product'] as $prod) {
                if (strtolower($prod['status']) !== 'active') {
                    continue;
                }

                $hostname = !empty($prod['domain']) ? $prod['domain'] : 'No hostname';

                if (!empty($prod['dedicatedip'])) {
                    $ip = trim($prod['dedicatedip']);
                    if (strpos($ip, '45') === 0 && !isset($ipSet[$ip])) {
                        $services[] = ['ip' => $ip, 'hostname' => $hostname];
                        $ipSet[$ip] = true;
                    }
                }

                if (!empty($prod['assignedips'])) {
                    $extraIps = explode(',', $prod['assignedips']);
                    foreach ($extraIps as $ipVal) {
                        $ip = trim($ipVal);
                        if (strpos($ip, '45') === 0 && !isset($ipSet[$ip])) {
                            $services[] = ['ip' => $ip, 'hostname' => $hostname];
                            $ipSet[$ip] = true;
                        }
                    }
                }
            }
        }

    }

    $language = $_SESSION['Language'];

    $availableLanguages = ['spanish', 'english'];

    if (!in_array($language, $availableLanguages)) {
        $language = 'english';
    }

  //  include __DIR__ . '/lang/' . $language . '.php';


    return [
        'pagetitle'    => 'Firewall Management - NeoProtect',
        'breadcrumb'   => [
            'index.php?m=neoprotect_module' => 'NeoProtect Module',
        ],
        'templatefile' => 'overview',
        'requirelogin' => true,
        'vars'         => [
            'services' => $services,
            'clientId' => $clientId,
          //  'langModule'     => $_ADDONLANG,
        ],
    ];
}
