use type Nazg\Glue\Scope;
use type Nazg\Glue\ApcCache;
use type Nazg\Glue\DependencyFactory;
use type Nazg\Glue\ProviderInterface;
use type Nazg\Glue\DependencyProvider;
use type Nazg\Glue\Serializer\HackSerializer;
use type Nazg\Glue\Serializer\HackUnserializer;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ApcCacheTest extends HackTest {
  const string KEYNAME = 'nazg-cache';

  public function testShouldNotExistsFile(): void {
    $serializeFilesystem = new ApcCache(self::KEYNAME);
    expect($serializeFilesystem->exists())->toBeFalse();
  }

  public function testSerializedBindingsAndUnserialized(): void {
    $bindings = dict[
      'stdClass' => tuple(new DependencyProvider(new stdClassProvider()), Scope::SINGLETON)
    ];
    $serialize = new ApcCache(self::KEYNAME);
    $serialize->save(new HackSerializer($bindings));
    expect($serialize->exists())->toBeTrue();
    $result = $serialize->read(new HackUnserializer());
    expect($result)->toContainKey('stdClass');
    $dependency = $result['stdClass'][0];
    expect($dependency->resolve(new Nazg\Glue\Container(new DependencyFactory()), Scope::SINGLETON))
      ->toBeInstanceOf(\stdClass::class);
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    @apc_delete(self::KEYNAME);
  }
}

final class stdClassProvider implements ProviderInterface<\stdClass> {

  public function get(\Nazg\Glue\Container $_container): \stdClass {
    return new \stdClass();
  }
}
