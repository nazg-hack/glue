use type Nazg\Glue\Scope;
use type Nazg\Glue\Container;
use type Nazg\Glue\FileCache;
use type Nazg\Glue\ProviderInterface;
use type Nazg\Glue\DependencyProvider;
use type Nazg\Glue\Serializer\HackSerializer;
use type Nazg\Glue\Serializer\HackUnserializer;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class FileCacheTest extends HackTest {
  const string FILENAME = __DIR__ . '/resources/serialize.file';

  public function testShouldNotExistsFile(): void {
    $serializeFilesystem = new FileCache(self::FILENAME);
    expect($serializeFilesystem->exists())->toBeFalse();
  }

  public async function testSerializedBindingsAndUnserialized(): Awaitable<void> {
    $bindings = dict[
      'stdClass' => tuple(new DependencyProvider(new stdClassProvider()), Scope::SINGLETON)
    ];
    $serializeFilesystem = new FileCache(self::FILENAME);
    await $serializeFilesystem->saveAsync(new HackSerializer($bindings));
    expect($serializeFilesystem->exists())->toBeTrue();
    $result = await $serializeFilesystem->readAsync(new HackUnserializer());
    expect($result)->toContainKey('stdClass');
    $dependency = $result['stdClass'][0];
    expect($dependency->resolve(new Nazg\Glue\Container(), Scope::SINGLETON))
      ->toBeInstanceOf(\stdClass::class);
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    @unlink(self::FILENAME);
  }
}

final class stdClassProvider implements ProviderInterface<\stdClass> {

  public function get(\Nazg\Glue\Container $container): \stdClass {
    return new \stdClass();
  }
}
