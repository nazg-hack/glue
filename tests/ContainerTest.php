<?hh // strict

use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Nazg\Glue\Injection\LazyNew;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testHasIdentifierShoulbReturnBool(): void {
    $container = new Container();
    $container->lock();
    expect($container->has(\stdClass::class))->toBeFalse();
    $container->unlock();
    $container->set(
      new LazyNew(\stdClass::class),
    );
    $container->lock();
    expect($container->has(\stdClass::class))->toBeTrue();
  }

  public function testShouldBePrototypeInstance(): void {
    $container = new Container();
    $container->set(new LazyNew(\stdClass::class));
    $container->lock();
    $stdClass = $container->getInstance(\stdClass::class);
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    expect($container->getInstance(\stdClass::class))->toNotBeSame($stdClass);
  }

  public function testShouldBeSingletonInstance(): void {
    $container = new Container();
    $container->set(
      new LazyNew(\stdClass::class),
      Scope::SINGLETON,
    );
    $container->lock();
    $stdClass = $container->getInstance(\stdClass::class);
    /* HH_FIXME[4053] for testing */
    $stdClass->testing = 1;
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    $second = $container->getInstance(\stdClass::class);
    expect($second)->toBeSame($stdClass);
    /* HH_FIXME[4053] for testing */
    expect($second->testing)->toBeSame(1,);
  }

  <<ExpectedException(Exception\ContainerNotLockedException::class)>>
  public function testShouldThrowContainerNotLockedException(): void {
    $container = new Container();
    $container->has(\stdClass::class);
  }

  <<ExpectedException(Exception\NotFoundException::class)>>
  public function testShouldThrowContainerNotLockedExceptionw(): void {
    $container = new Container();
    $container->set(
      new LazyNew(\stdClass::class),
      Scope::SINGLETON,
    );
    $container->lock();
    $container->getInstance(Mock::class);
  }
}

final class Mock {

}
