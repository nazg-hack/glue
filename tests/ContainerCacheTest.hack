use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\ContainerCache;
use type Nazg\Glue\SerializeFile;
use type Nazg\Glue\Scope;
use type Nazg\Glue\ProviderInterface;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerCacheTest extends HackTest {

  const string FILENAME = __DIR__ . '/resources/testing.cache';

  public async function testShouldCreateSerializeFile(): Awaitable<void> {
    $container = new Container(
      new ContainerCache(new SerializeFile(self::FILENAME))
    );
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Any::class)
      ->provider(new AnyProvider());
    await $container->lockAsync();
    expect(file_exists(self::FILENAME))
      ->toBeTrue();
  }

  public async function testShouldReturnInstanceFromSerializeFile(): Awaitable<void> {
    $container = new Container(
      new ContainerCache(new SerializeFile(self::FILENAME))
    );
    await $container->lockAsync();
    expect($container->get(Any::class))
      ->toBeInstanceOf(Any::class);
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    unlink(self::FILENAME);
  }
}
