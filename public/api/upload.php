<?php
require_once __DIR__ . '/../../vendor/autoload.php';

use Symfony\Component\Process\Process;
use League\Flysystem\Filesystem;
use League\Flysystem\Adapter\Local;
use Nette\Http;

// Initial value
$factory = new Http\RequestFactory;
$request = $factory->createHttpRequest();
$response = new Http\Response;

// Get the file uploaded
$file = $request->getFile('java_class');

// Move the file to storage folder
$file->move(__DIR__.'/../../storage/'.$file->getName());

// Get class name based on file name
$class_name = str_replace('.java', '', $file->getName());

// Prepare the command
$command = 'cd '. __DIR__ . '/../../storage/' . ' && ' .
           'javac '.$file->getName().' && ' .
           'java -cp gson-2.3.1.jar:. Reflection ' . $class_name;

// Run the command
$process = new Process($command);
$process->run();

// Set the response
$response->setCode(Http\IResponse::S200_OK);
$response->setContentType('application/json');

echo $process->getOutput();

// Adapter for file system
$adapter = new Local(__DIR__.'/../../storage/');
$filesystem = new Filesystem($adapter);

// Delete files
$filesystem->delete($class_name . '.java');
$filesystem->delete($class_name . '.class');


function dd($var){
    echo '<pre>';
    var_dump($var);
    echo '</pre>';
    die();
}