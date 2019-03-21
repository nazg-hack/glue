use type Nazg\Glue\ContainerBuilder;
use type Nazg\Glue\Scope;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class CachedContainerTest extends HackTest {

  const string FILENAME = __DIR__ . '/resources/testing.cache';

  public async function testShouldCreateSerializeFile(): Awaitable<void> {
    $builder = new ContainerBuilder(true, self::FILENAME);
    $container = $builder->make();
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Any::class)
      ->provider(new AnyProvider());
    await $container->lockAsync();
    expect(file_exists(self::FILENAME))
      ->toBeTrue();
  }

  // Irregular! Deprecated Usage.
  public async function testShouldReturnInstanceFromSerializeFile(): Awaitable<void> {
    $builder = new ContainerBuilder(true, self::FILENAME);
    $container = $builder->make();
    await $container->lockAsync();
    expect($container->get(Any::class))
      ->toBeInstanceOf(Any::class);
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    @unlink(self::FILENAME);
  }
}
