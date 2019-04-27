use type Nazg\Glue\ContainerBuilder;
use type Nazg\Glue\Scope;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class CachedContainerTest extends HackTest {

  const string KEYNAME = 'CachedContainerTest';

  public async function testShouldCreateSerialize(): Awaitable<void> {
    $builder = new ContainerBuilder(true, self::KEYNAME);
    $container = $builder->make();
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Any::class)
      ->provider(new AnyProvider());
    await $container->lockAsync();
    expect(apc_exists(self::KEYNAME))->toBeTrue();
  }

  // Irregular! Deprecated Usage.
  public async function testShouldReturnInstanceFromSerializeFile(): Awaitable<void> {
    $builder = new ContainerBuilder(true, self::KEYNAME);
    $container = $builder->make();
    await $container->lockAsync();
    expect($container->get(Any::class))
      ->toBeInstanceOf(Any::class);
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    @unlink(self::KEYNAME);
  }
}
