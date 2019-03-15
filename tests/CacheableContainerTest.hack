use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\ContainerConfig;
use type Nazg\Glue\Scope;
use type Nazg\Glue\ProviderInterface;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;
use function file_exists;
use function unlink;

final class CacheableContainerTest extends HackTest {
  private static string $filename = __DIR__ .'/resources/container.cache.hack';

  public function testShoulbReturnPrototypeInstance(): void {
    $container = new Container(
      new ContainerConfig(true, self::$filename)
    );
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->lock();
    expect($container->get(Mock::class))
      ->toNotBeSame($container->get(Mock::class));
    expect(file_exists(self::$filename))->toBeTrue();
  }

  <<__Override>>
  public static async function afterLastTestAsync(): Awaitable<void> {
    if (file_exists(self::$filename)) {
      unlink(self::$filename);
    }
  }
}
