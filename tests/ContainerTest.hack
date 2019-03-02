use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testHasIdentifierShoulbReturnBool(): void {
    $container = new Container();
    $container->lock();
    expect($container->has(\stdClass::class))->toBeFalse();
    $container->unlock();
    $container->set(
      \stdClass::class,
      ($container) ==> new \stdClass()
    );
    $container->lock();
    expect($container->has(\stdClass::class))->toBeTrue();
  }

  public function testShouldBePrototypeInstance(): void {
    $container = new Container();
    $container->set(
      \stdClass::class,
      ($container) ==> new \stdClass()
    );
    $container->lock();
    $stdClass = $container->get(\stdClass::class);
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    expect($container->get(\stdClass::class))->toNotBeSame($stdClass);
  }

  public function testShouldBeSingletonInstance(): void {
    $container = new Container();
    $container->set(
      \stdClass::class,
      ($container) ==> new \stdClass(),
      Scope::SINGLETON,
    );
    $container->lock();
    $stdClass = $container->get(\stdClass::class);
    /* HH_FIXME[4053] for testing */
    $stdClass->testing = 1;
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    $second = $container->get(\stdClass::class);
    expect($second)->toBeSame($stdClass);
    /* HH_FIXME[4053] for testing */
    expect($second->testing)->toBeSame(1,);
  }

  public function testShouldThrowContainerNotLockedException(): void {
    $container = new Container();
    expect(() ==> $container->has(\stdClass::class))
      ->toThrow(Exception\ContainerNotLockedException::class);
  }

  public function testShouldThrowContainerNotLockedExceptionw(): void {
    $container = new Container();
    $container->set(
      \stdClass::class,
      ($container) ==> new \stdClass(),
      Scope::SINGLETON,
    );
    $container->lock();
    expect($container->has(Mock::class))->toBeFalse();
    expect(() ==> $container->get(Mock::class))
      ->toThrow(Exception\NotFoundException::class);
  }
}

final class Mock {

}
